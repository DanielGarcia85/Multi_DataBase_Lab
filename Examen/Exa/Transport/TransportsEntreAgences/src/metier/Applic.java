package metier;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import dao.BddMongo;
import dao.BddNeo4j;
import dao.BddOracle;
import org.bson.Document;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static dao.BddOracle.connection;

public class Applic {
    private BddOracle oracle = new BddOracle();
    private MongoDatabase mongodb = new BddMongo().connect();
    private BddNeo4j neo4j = new BddNeo4j();

    public Applic() {
        //nouveauTransport(66, 1, 3);
        //nouveauTransport(100, 1, 4);

        //modifierPoidsMaxDuTransport(2, 222);
        //modifierPoidsMaxDuTransport(3, 333);

        //supprimerLeTransport(2);
        //supprimerLeTransport(3);

        //copierLeTransportDansMongoDb(1);
        //copierLeTransportDansMongoDb(2);
        //copierLeTransportDansMongoDb(3);
        //copierLeTransportDansMongoDb(4);
        //copierLeTransportDansMongoDb(5);

        afficherChemin(1, 2);
        afficherChemin(1, 4);
        afficherChemin(3, 5);
        afficherChemin(8, 9);
        afficherChemin(8, 1);
        afficherChemin(1, 9);
    }

    /** Insère un nouveau transport dans la bdd Oracle (en passant par la vue vw_exa_transports). 
        Les 3 seuls champs à fournir à la vue sont le poidsMax, le noAgence de départ et d'arrivée.
        Tout le reste est géré automatiquement sur le serveur (par un trigger !). */
    private void nouveauTransport(int poidsMax, int noAgenceDepart, int noAgenceArrivee) {
        try {
            oracle.query("INSERT INTO vw_exa_transports (poids_max, depart, arrivee) VALUES (" + poidsMax + ", " + noAgenceDepart + ", " + noAgenceArrivee + ")");
            //connection.createStatement().executeQuery("INSERT INTO vw_exa_transports (poids_max, depart, arrivee) VALUES (" + poidsMax + ", " + noAgenceDepart + ", " + noAgenceArrivee + ")");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Modifie le poids maximum d'un transport (en passant par la vue vw_exa_transports) */
    private void modifierPoidsMaxDuTransport(int noTransport, int nouveauPoidsMax) {
        try {
            oracle.query("UPDATE vw_exa_transports SET poids_max =  " + nouveauPoidsMax + " WHERE numero = " + noTransport);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Supprime un transport de la bdd Oracle (en passant par la vue vw_exa_transports)
        Le message « Impossible de supprimer le transport n°2 (déjà effectué !) » est affiché le cas échéant. */
    private void supprimerLeTransport(int noTransport) {
        try {
            oracle.query("DELETE vw_exa_transports WHERE numero = " + noTransport);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Recopie un transport de la bdd Oracle dans MongoDB.
        Une collection MongoDB « Agence » existe déjà ! */
    private void copierLeTransportDansMongoDb(int noTransport) {
        try {
            ResultSet resTransport = oracle.query("SELECT * FROM exa_transport WHERE tra_no = "+noTransport);

            MongoCollection collTransport = mongodb.getCollection("Transport");
            //collTransport.drop();
            MongoCollection collAgence = mongodb.getCollection("Agence");
            while(resTransport.next()){
                Document docDepart = (Document) collAgence.find(Filters.gte("no", resTransport.getInt("tra_age_depart"))).first();
                Document docArrivee = (Document) collAgence.find(Filters.gte("no", resTransport.getInt("tra_age_arrivee"))).first();
                ResultSet resColis = oracle.query("SELECT * FROM exa_colis WHERE col_tra_no = "+noTransport);
                ArrayList<Document> arrDocument = new ArrayList<>();
                Document docColis = null;
                while(resColis.next()){
                    docColis = new Document("no", resColis.getString("col_no")).append("poids", resColis.getString("col_poids"));
                    arrDocument.add(docColis);;
                    }
                collTransport.insertOne(new Document("no_transport",resTransport.getInt("tra_no")).append("poids_max",resTransport.getInt("tra_poids_max")).append("depart",docDepart). append("arrivee",docArrivee).append("colis",arrDocument));
                collTransport.updateOne(Filters.eq("no_transport", resTransport.getInt("tra_no")), Updates.push("colis", new Document ("no", "4444").append("poids", "444")));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /** Affiche le chemin (la distance) pour aller de l’agence de départ à l’agence d’arrivée */
    private void afficherChemin(int noAgenceDepart, int noAgenceArrivee) {
        System.out.print(noAgenceDepart + " -> " + noAgenceArrivee + " ==> ");
        Result res1 = neo4j.run("Match (a:Agence {no:" + noAgenceDepart + "}) return a");
        Result res2 = neo4j.run("Match (a:Agence {no:" + noAgenceArrivee + "}) return a");
        if(!res1.hasNext() || !res2.hasNext()){
            System.out.print("Agence inconnue !");
        }else{
            Record rec1 = res1.next();
            String agenceDep = String.valueOf(rec1.get("a").get("nom"));
            Record rec2 = res2.next();
            String agenceArr= String.valueOf(rec2.get("a").get("nom"));
            System.out.print("Le trajet de " + agenceDep + " vers " + agenceArr);
            Result res3 = neo4j.run("MATCH p=shortestPath((dep:Agence {no: "+noAgenceDepart+"})-[*]->(arr:Agence {no: "+noAgenceArrivee+"}))  UNWIND relationships(p) AS dist RETURN dist.distance as dist");
            if(!res3.hasNext()){
                System.out.print(" n'existe pas !");
            }else{
                Record rec3 = res3.next();
                if(res3.hasNext()){
                    System.out.print(" passe par d'autres agences et fait " + rec3.get("dist") + " km");
                }else {
                    System.out.print(" fait " + rec3.get("dist") + " km");
                }
            }
        }
        System.out.println();
    }
}