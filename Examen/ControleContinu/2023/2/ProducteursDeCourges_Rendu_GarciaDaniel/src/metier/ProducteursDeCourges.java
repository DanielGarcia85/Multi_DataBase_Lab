package metier;



import java.util.*;
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
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import static dao.Bdd.jedis;
import static dao.Bdd.neo4j;
import static dao.Bdd.mongo;

public class ProducteursDeCourges {

    public ProducteursDeCourges() {
        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)
        afficherGrosProducteurs("Carouge", "Potiron", 60);
        ajouterNouveauFournisseurPour("Muscade", "Migros");
        enregistrerLeTotalRedisDansStatMongo();
        afficherGrosProducteurs("Carouge", "Spaghetti", 80);
    }

	private void afficherGrosProducteurs(String lieu, String courge, int nb) {
        List<Producteur> producteurs = new ArrayList<>();
        // TODO: Créez des instances de la classe Producteur pour chaque producteur de <lieu> (la liste des producteurs et leur lieu sont dans MongoDB)
        //       pour autant que ce producteur ait déjà produit plus de <nb> <courges> cette année (donc selon les nombres indiqués dans Redis)
        //       indiquez également les magasins qui se fournissent chez ce producteur (cette liste est indiquée avec <FOURNIT> dans Neo4j)
        //       puis affichez l'ArrayList producteurs (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)

        MongoCollection col = mongo.getCollection("Producteurs");
        MongoCursor<Document> cursor = col.find(Filters.eq("lieu", lieu)).cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();

            // Il me manque la partie Jedis pour les stats

            //Set<String> prod = jedis.smembers(doc.get("nom").toString());
            //System.out.println(prod);

            Result res = neo4j.run("MATCH (p:Producteur {nom:'" + doc.get("nom") + "'})-[r:FOURNIT]->(m:Magasin) RETURN m.nom as nom");
            List<String> listMag = new ArrayList<>();
            while(res.hasNext()) {
                Record rec = res.next();
                listMag.add(rec.get("nom").toString());
            }
            Producteur p = new Producteur(doc.getString("nom"), doc.getString("lieu"), null, listMag);
            producteurs.add(p);
        }
        System.out.println("Liste des producteurs de " + lieu + " qui ont déjà produit cette année plus de " + nb + " " + courge + " :");
        for (Producteur p : producteurs) System.out.println(p);  // l'affichage des gros producteurs de <lieu> doit se faire ici
    }

    private void ajouterNouveauFournisseurPour(String courge, String magasin) {
        // TODO: Indiquez dans Neo4j que chaque Producteur qui cultive actuellement des <courge> fournit dorénavant le magasin spécifié
        System.out.println("On a ajouté ces producteurs de courges '" + courge + "' comme nouveau fournisseur de la " + magasin + " (car ils cultivent des " + courge + " cette année) :");
        Result res = neo4j.run("MATCH (p:Producteur)-[r:CULTIVE]->(c:Courge {nom:'" + courge + "'}) WHERE size(keys(r))=0 RETURN p.nom as prodnom");
        while(res.hasNext()) {
            Record rec = res.next();
            String prodNom = rec.get("prodnom").toString();
            neo4j.run("MATCH (p:Producteur {nom:'" + prodNom + "'}), (m:Magasin {nom:'" + magasin + "'}) CREATE (p)-[:FOURNIT]->(m)");
            System.out.println(prodNom);
        }
    }

    private void enregistrerLeTotalRedisDansStatMongo() {
        // TODO: Ajoutez à chaque Producteur de MongoDB une nouvelle stat pour l'année 2023 avec les quantités actuelles (faire la somme des valeurs dans Redis pour ce producteur)
        System.out.println("Voici les productions actuelles, qui vont être enregistrées dans MongoDB :");
        MongoCollection col = mongo.getCollection("Producteurs");
        MongoCursor<Document> cursor = col.find().cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            String nomProd = doc.get("nom").toString();

            // Il me manque à récupérer le total dans Redis que je n'ai pas réussi
            Set<String> prod = jedis.smembers(nomProd);
            int total = 0;
            for (String s : prod) {
                total += Integer.parseInt(jedis.hget(doc.get("nom").toString(), s));
            }
            Statistique stat = new Statistique(2023, total);
            String jsonStat = new Gson().toJson(stat);
            Document doc2 = Document.parse(jsonStat);
            col.updateOne(Filters.eq("nom", doc.get("nom")), new Document("$push", new Document("stat", doc2)));
        }
    }

}