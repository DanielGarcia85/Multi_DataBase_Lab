package metier;



import java.sql.ResultSet;
import java.sql.SQLException;
import static dao.Bdd.*;
import com.google.gson.Gson;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import dao.Bdd;
import domaine.Producteur;
import domaine.Statistique;
import org.bson.Document;
import org.neo4j.driver.Result;
import org.neo4j.driver.Record;
import org.neo4j.driver.internal.shaded.io.netty.util.internal.ReflectionUtil;


import javax.print.Doc;
import java.util.*;

import static dao.Bdd.jedis;
import static dao.Bdd.neo4j;
import static dao.Bdd.mongo;
import static dao.Bdd.oracle;

public class ProducteursDeCourges {
    public ProducteursDeCourges() {

        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)

        afficherLesDonneesJedis();
        afficherLesDonneesMongoDB();
        afficherLesDonneesNeo4J();

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
        MongoCursor curs = coll.find(Filters.eq("lieu", lieu)).cursor();
        while(curs.hasNext()){
            Document doc = (Document) curs.next();
            String nomProd = doc.get("nom").toString();
            String lieuProd = doc.get("lieu").toString();
            String nbCourge = jedis.hget(nomProd, courge);
            if (nbCourge != null && Integer.parseInt(nbCourge) > nb) {
                List<Document> listDocStat = doc.getList("stat", Document.class);
                List<Statistique> listStat = new ArrayList<Statistique>();
                for(int i=0; i<listDocStat.size(); i++){
                    Document docStat = listDocStat.get(i);
                    Statistique stat = new Gson().fromJson(docStat.toJson(), Statistique.class);
                    // ou
                    //Statistique stat = new Statistique(docStat.getInteger("annee"), docStat.getInteger("nb"));
                    listStat.add(stat);
                }
                Result res = neo4j.run("match (p:Producteur{nom:'"+nomProd+"'})-[f:FOURNIT]->(m:Magasin) return m.nom as nomMag");
                ArrayList<String> listMag = new ArrayList<String>();
                while(res.hasNext()){
                    Record rec = res.next();
                    String mag = rec.get("nomMag").toString();
                    listMag.add(mag);
                }
                Producteur prod = new Producteur(nomProd, lieuProd, listStat, listMag);
                producteurs.add(prod);
            }
        }
        System.out.println("Liste des producteurs de " + lieu + " qui ont déjà produit cette année plus de " + nb + " " + courge + " :");
        for (Producteur p : producteurs) {
            System.out.println(p);
        }
        System.out.println();
    }

    private void ajouterNouveauFournisseurPour(String courge, String magasin) {
        System.out.println("On a ajouté ces producteurs de courges '" + courge + "' comme nouveau fournisseur de la " + magasin + " (car ils cultivent des " + courge + " cette année) :");
        Result res = neo4j.run("match(p:Producteur)-[r:CULTIVE]->(c:Courge{nom:'"+courge+"'}), (m:Magasin{nom:'"+magasin+"'}) where r.annee is null  create (p)-[:FOURNIT]->(m) return distinct p.nom as nomProd");
        while (res.hasNext()){
            Record rec = res.next();
            System.out.println(rec.get("nomProd").toString());
        }
        System.out.println();
    }

    private void enregistrerLeTotalRedisDansStatMongo() {
        // TODO: Ajoutez à chaque Producteur de MongoDB une nouvelle stat pour l'année 2023 avec les quantités actuelles (faire la somme des valeurs dans Redis pour ce producteur)
        System.out.println("Voici les productions actuelles, qui vont être enregistrées dans MongoDB :");
        MongoCollection coll = mongo.getCollection("Producteurs");
        MongoCursor curs = coll.find().cursor();
        while (curs.hasNext()){
            Document doc = (Document) curs.next();
            String nomProd = doc.getString("nom");
            int total = 0;
            Result res = neo4j.run("match (c:Courge) return distinct c.nom as nomCourge");
            while (res.hasNext()){
                Record rec = res.next();
                String nomCourge = rec.get("nomCourge").asString();
                String nbCourge = jedis.hget(nomProd, nomCourge);
                if(nbCourge != null){
                    total = total + Integer.parseInt(nbCourge);
                }
            }
            Document docStat2023 = new Document("annee", 2023).append("nb", total);
            //ou
            //Statistique stat = new Statistique(2023, total);
            //String jsonStat = new Gson().toJson(stat);
            //Document docStat2023 = Document.parse(jsonStat);
            coll.updateOne(Filters.eq("nom", nomProd), new Document("$push", new Document("stat", docStat2023)));
            System.out.println("- " + nomProd + " : 2023:" + total);
        }
        System.out.println();
    }

    private void afficherLesDonneesJedis() {
        System.out.println();
        System.out.println("Donnée dans Jedis :");
        System.out.println("-------------------");
        Set<String> keys = jedis.keys("*");
        for (String key : keys){
            String type = jedis.type(key);
            if(type.equals("hash")){
                System.out.println("Clé    : " + key + " (" + type + ")");
                System.out.println("Valeur : " + jedis.hgetAll(key));
            }
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

}