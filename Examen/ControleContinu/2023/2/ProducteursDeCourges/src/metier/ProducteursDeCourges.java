package metier;



import java.sql.ResultSet;
import java.sql.SQLException;
import static dao.Bdd.*;
import com.google.gson.Gson;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
import dao.Bdd;
import domaine.Producteur;
import domaine.Statistique;
import org.bson.Document;
import org.neo4j.driver.Result;
import org.neo4j.driver.Record;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static dao.Bdd.jedis;
import static dao.Bdd.neo4j;
import static dao.Bdd.mongo;
import static dao.Bdd.oracle;

 public class ProducteursDeCourges {

    public ProducteursDeCourges() {
        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)

        afficherLesDonneesJedis();
        afficherGrosProducteurs("Carouge", "Potiron", 60);
        ajouterNouveauFournisseurPour("Muscade", "Migros");
        enregistrerLeTotalRedisDansStatMongo();
        afficherGrosProducteurs("Carouge", "Spaghetti", 80);
        //accederALaBaseOracle();
    }

    private void accederALaBaseOracle() {
        // try catch obligatoire dès qu'on fait des requetes SQL
        try {
            oracle.createStatement().execute("CREATE TABLE Producteur (nom VARCHAR(20), lieu VARCHAR(20))");
            ResultSet res = oracle.createStatement().executeQuery("SELECT * FROM Producteur");
            while(res.next()){
                System.out.println(res.getString("nom")+ " " + res.getString("lieu"));
            }
            oracle.createStatement().execute("INSERT INTO Producteur VALUES ('test', 'test')");
            oracle.createStatement().execute("UPDATE...");
            oracle.createStatement().execute("DELETE...");
            oracle.createStatement().execute("BEGIN nomDuPkg.nomDeLaProcedure('test'); END;");
            // Dans le cas d'une fonciton faire un executeQuery et récupérer le résultat dans un ResultSets

        } catch (SQLException e) {

            // faire un raise application error dans le code du trigger dans PLSQL par exemple
            // pour pouvoir le récupérer ici
            // utiliser les code d'erreur 20001, 20002, 20003, etc.
            System.out.println("Erreur lors de la connexion à la base Oracle");
            switch (e.getErrorCode()){
                case -20001 : System.out.println("Erreur : " + e.getMessage()); e.getMessage(); break;
                case -20002 : System.out.println("Erreur : " + e.getMessage()); break;
            }
        }
    }

	private void afficherGrosProducteurs(String lieu, String courge, int nb) {
        List<Producteur> producteurs = new ArrayList<>();
        // TODO: Créez des instances de la classe Producteur pour chaque producteur de <lieu> (la liste des producteurs et leur lieu sont dans MongoDB)
        //       pour autant que ce producteur ait déjà produit plus de <nb> <courges> cette année (donc selon les nombres indiqués dans Redis)
        //       indiquez également les magasins qui se fournissent chez ce producteur (cette liste est indiquée avec <FOURNIT> dans Neo4j)
        //       puis affichez l'ArrayList producteurs (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)

        MongoCollection coll = mongo.getCollection("Producteurs");
        MongoCursor<Document> cursor = coll.find(Filters.eq("lieu", lieu)).cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            String nomProd = (String) doc.get("nom");
            String lieuProd = (String) doc.get("lieu");

            // Ou sinon récupérer directement de cette façon (ainsi on a aussi les stats dedans et on se passe du bloc listStat)
            // et ensuite rajouter les magasins

            //Producteur pp = new Gson().fromJson(doc.toJson(), Producteur.class);

            String strNbCourge = jedis.hget(nomProd, courge);
            if(strNbCourge != null && Integer.parseInt(strNbCourge) > nb) {

                ArrayList<Document> listDoc = (ArrayList<Document>) doc.getList("stat", Document.class);
                List<Statistique> listStat = new ArrayList<>();
                for(Document docStat : listDoc){
                    Statistique stat = new Statistique(docStat.getInteger("annee"), docStat.getInteger("nb"));
                    listStat.add(stat);
                }

                Result res = neo4j.run("MATCH (p:Producteur {nom:'" + nomProd + "'})-[r:FOURNIT]->(m:Magasin) RETURN m.nom as nom");
                List<String> listMag = new ArrayList<>();
                while(res.hasNext()) {
                    Record rec = res.next();
                    listMag.add(rec.get("nom").toString());
                    //pp.addMagasin(rec.get("nom").toString());

                }

                Producteur p = new Producteur(nomProd, lieuProd, listStat, listMag);
                producteurs.add(p);

            }
        }
        System.out.println("Liste des producteurs de " + lieu + " qui ont déjà produit cette année plus de " + nb + " " + courge + " :");
        for (Producteur p : producteurs) System.out.println(p);  // l'affichage des gros producteurs de <lieu> doit se faire ici
        System.out.println();
    }

    private void ajouterNouveauFournisseurPour(String courge, String magasin) {
        // TODO: Indiquez dans Neo4j que chaque Producteur qui cultive actuellement des <courge> fournit dorénavant le magasin spécifié
        System.out.println("On a ajouté ces producteurs de courges '" + courge + "' comme nouveau fournisseur de la " + magasin + " (car ils cultivent des " + courge + " cette année) :");
        Result res = neo4j.run("MATCH (p:Producteur)-[r:CULTIVE]->(c:Courge {nom:'" + courge + "'}) WHERE size(keys(r))=0 RETURN p.nom as prodnom");
        // Result res = neo4j.run("MATCH (p:Producteur)-[r:CULTIVE]->(c:Courge {nom:'" + courge + "'}) WHERE r.annee is null RETURN p.nom as prodnom");
        while(res.hasNext()) {
            Record rec = res.next();
            String prodNom = rec.get("prodnom").asString();
            neo4j.run("MATCH (p:Producteur {nom:'" + prodNom + "'}), (m:Magasin {nom:'" + magasin + "'}) CREATE (p)-[:FOURNIT]->(m)");
            System.out.println(prodNom);
        }
        System.out.println();
    }

    private void enregistrerLeTotalRedisDansStatMongo() {
        // TODO: Ajoutez à chaque Producteur de MongoDB une nouvelle stat pour l'année 2023 avec les quantités actuelles (faire la somme des valeurs dans Redis pour ce producteur)
        System.out.println("Voici les productions actuelles, qui vont être enregistrées dans MongoDB :");
        MongoCollection coll = mongo.getCollection("Producteurs");
        MongoCursor<Document> cursor = coll.find().cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            String nomProd = doc.get("nom").toString();

            int total = 0;
            Result res2 = neo4j.run("match (c:Courge) return c.nom as nomCourge");
            while (res2.hasNext()){
                Record rec2 = res2.next();
                String nomCourge = rec2.get("nomCourge").asString();
                String valeur = jedis.hget(nomProd, nomCourge);
                if(valeur != null){
                    Integer nb = Integer.valueOf(valeur);
                    total = total + nb;
                }
            }

            // Ou bien, à la place du paragraphe précédant :
            // Map<String, String> currentMap = jedis.hgetAll(nomProd);
            // int total = currentMap.values().stream().map(Integer::parseInt).reduce(0, Integer::sum);

            Statistique stat = new Statistique(2023, total);
            String jsonStat = new Gson().toJson(stat);
            Document docStat = Document.parse(jsonStat);
            coll.updateOne(Filters.eq("nom", nomProd), new Document("$push", new Document("stat", docStat)));

            System.out.println(nomProd + " | 2023:" + total);
        }
        System.out.println();
    }

    private void afficherLesDonneesJedis() {
        System.out.println();
        System.out.println("Donnée dans Jedis :");
        System.out.println("-------------------");
        Set<String> keys = jedis.keys("*");
        for (String key : keys) {
            String type = jedis.type(key);
            System.out.println("Type   : " + type);
            System.out.println("Clé    : " + key);
            if (type.equals("string")) {
                System.out.println("Valeur : " + jedis.get(key));
            }
            if (type.equals("hash")) {
                    System.out.println("Valeur : " + jedis.hgetAll(key));
                    System.out.println();;
            }
            System.out.println("-----");
        }
    }

     private void afficherLesDonneesNeo4J() {
         Result res = neo4j.run("match(n) return n.nom as nom, labels(n) as type");
         while (res.hasNext()){
             Record rec = res.next();
             String nom = rec.get("nom").toString();
             String type = rec.get("type").toString();
             System.out.println(nom + " : " + type);
         }
         System.out.println();
     }

     private void afficherLesDonneesMongoDB() {
         MongoCollection coll = mongo.getCollection("Producteurs");
         MongoCursor curs = coll.find().cursor();
         while (curs.hasNext()){
             Document doc = (Document) curs.next();
             String nomProd = doc.getString("nom");
             String lieuProd = doc.getString("lieu");
             List<Document> listDocStat = doc.getList("stat", Document.class);
             ArrayList<Statistique> listStat = new ArrayList<Statistique>();
             for(int i=0; i< listDocStat.size(); i++){
                 Document docStat = listDocStat.get(i);
                 Statistique stat = new Gson().fromJson(docStat.toJson(), Statistique.class);
                 listStat.add(stat);
             }
             Result res = neo4j.run("match (p:Producteur{nom:'"+nomProd+"'})-[]->(m:Magasin) return m.nom as nomMag");
             ArrayList<String> listMag = new ArrayList<String>();
             while(res.hasNext()){
                 Record rec = res.next();
                 String mag = rec.get("nomMag").toString();
                 listMag.add(mag);
             }
             Producteur prod = new Producteur(nomProd, lieuProd, listStat, listMag);
             System.out.println(prod);
         }
         System.out.println();
     }

}