package metier;

import com.google.gson.Gson;
import com.mongodb.Mongo;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
import dao.Bdd;
import domaine.Nuitee;
import domaine.Transport;
import domaine.Voyage;
import org.bson.Document;
import org.neo4j.driver.Result;
import org.neo4j.driver.Record;
import redis.clients.jedis.Jedis;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import static dao.Bdd.jedis;
import static dao.Bdd.neo4j;

public class ListeDeVoyages {

    public ListeDeVoyages() {

        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)

        afficherLesDonneesRedis();
        afficherLesDonnesMongoDB();
        afficherLesDonneesNeo4j();

        creerLesVoyagesPour("bdd@heg.ch");
        autresTransportsPossiblesPour("LUX");
        modifierLesTransports("AVION", "KLM", "AVION", "AirFrance");
        modifierLesTransports("CAR", "Helvecie", "TRAIN", "CFF");
        ajouterVoyage("AMS", "Amsterdam", "Royal", "Imperial", "5*");
        sInscrireAuxVoyagesSelonNomHotel("Royal");
    }

    private void afficherLesDonneesNeo4j() {
        System.out.println();
        System.out.println("Donnée dans Neo4J :");
        System.out.println("---------------------");
        Result res = neo4j.run("match (a)-[b]-(c) return a.ville as ville1, type(b) as type, b.compagnie as comp, c.ville as ville2 order by ville1, ville2");
        while(res.hasNext()){
            Record rec = res.next();
            System.out.println(rec.get("ville1") + " " + rec.get("type") + " " + rec.get("comp") + " " + rec.get("ville2"));
        }
        System.out.println();
    }

    private void afficherLesDonnesMongoDB() {
        System.out.println();
        System.out.println("Donnée dans MongoDB :");
        System.out.println("---------------------");
        MongoCollection collection = Bdd.mongo.getCollection("Voyage");
        MongoCursor<Document> cursor = collection.find().cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            System.out.println(doc);
            System.out.println(new Gson().fromJson(doc.toJson(), Voyage.class));
        }
        cursor.close();
        System.out.println();
    }

    private void afficherLesDonneesRedis() {
        System.out.println();
        System.out.println("Donnée dans Jedis :");
        System.out.println("-------------------");
        Set<String> keys = jedis.keys("*");
        for(String key : keys){
            System.out.println("Clé : " + key + " - Valeur : " + jedis.smembers(key));
        }
        System.out.println();
    }

    private void creerLesVoyagesPour(String email) {
        // TODO: Créez des instances de la classe Voyage pour chaque destination à laquelle <email> s'est inscrit (dans Redis),
        //       supprimez ces inscriptions de Redis (ôtez son email des listes)
        //       puis affichez l'ArrayList voyages (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)
        List<Voyage> voyages = new ArrayList<>();
        Set<String> destinations = jedis.smembers("DESTINATIONS");
        for (String codeDest : destinations){
            if (jedis.sismember(codeDest, email)){
                Document doc = Bdd.mongo.getCollection("Voyage").find(Filters.eq("code", codeDest)).first();
                String nomDest = (String) doc.get("destination");
                ArrayList<Document> nuitees = (ArrayList) doc.get("nuitees");
                ArrayList<Nuitee> nuitees2 = new ArrayList<>();
                for (Document nuitee : nuitees){
                    Nuitee nuit = new Gson().fromJson(nuitee.toJson(), Nuitee.class);
                    nuitees2.add(nuit);
                }
                Result res = neo4j.run("match (dep:Depart)-[t]->(dest:Destination {code:'"+codeDest+"'}) return type(t) as type, t.compagnie as compagnie");
                ArrayList transports = new ArrayList();
                while (res.hasNext()){
                    Record rec = res.next();
                    Transport transp = new Transport(rec.get("type").toString(), rec.get("compagnie").toString());
                    transports.add(transp);
                }
                Voyage v = new Voyage(email, codeDest, nomDest, nuitees2, transports);
                voyages.add(v);
                jedis.srem(codeDest, email);
            }
        }
        System.out.println("Liste des voyages où " + email + " est inscrit :");
        for (Voyage v : voyages) System.out.println(v);  // l'affichage de tous les voyages pour <email> doit se faire ici
        System.out.println();
    }

    private void autresTransportsPossiblesPour(String code) {
        // TODO: Affichez les autres transports à destination de <code> qui ne partent pas du :Départ standard
        System.out.println("Autres transports à destination de " + code + " qui ne partent pas du Départ standard :");
        Result res = neo4j.run("match(depart:Destination)-[t]->(arr:Destination{code:'"+code+"'}) return depart, type(t) as type, t.compagnie as compagnie");
        while (res.hasNext()) {
            Record rec = res.next();
            System.out.println("en " + rec.get("type") + " (" + rec.get("compagnie") + ") via " + rec.get("depart").get("ville"));
        }
        System.out.println();
    }

    private void modifierLesTransports(String ancienType, String ancienneCompagnie, String nouveauType, String nouvelleCompagnie) {
        // TODO: Tous les transports de <ancienType> qui étaient effectués par l'<ancienneCompagnie> sont remplacés par les nouvelles données :
        System.out.println("Tous les transports en " + ancienType + " qui étaient effectués par " + ancienneCompagnie + " sont remplacés par les transport en " + nouveauType + " effectués par " + nouvelleCompagnie);
        Result res = neo4j.run("match (d)-[t:"+ancienType+"]->(a) where t.compagnie ='"+ancienneCompagnie+"' create (d)-[tt:"+nouveauType+"{compagnie:'MaComp'}]->(a)  delete t return  t, tt");
        System.out.println();
    }
    private void ajouterVoyage(String code, String destination, String nomHotel1, String nomHotel2, String cat) {
        // TODO: Ajoutez un nouveau voyage à destination de <code> dans lequel se trouve les 2 hôtels spécifiés
        MongoCollection coll = Bdd.mongo.getCollection("Voyage");
        Document doc = new Document("code", code).append("destination", destination).append("nuitees", Arrays.asList(new Document ("nom", nomHotel1), new Document("nom", nomHotel2).append("cat", cat)));
        coll.insertOne(doc);
        System.out.println("Ajout d'un nouveau voyage à destination de " + doc.get("destination") + " dans lequel se trouve les hôtels :");
        Document doc2 = (Document) coll.find(Filters.eq("destination", doc.get("destination"))).first();
        ArrayList<Document> nuitees = (ArrayList) doc2.get("nuitees");
        for (Document nuitee : nuitees){
            Nuitee hotel = new Gson().fromJson(nuitee.toJson(), Nuitee.class);
            System.out.println(" - " + hotel);
        }
        System.out.println();
    }

    private void sInscrireAuxVoyagesSelonNomHotel(String nomHotel) {
        // TODO: Inscrivez-vous (rajoutez vos initiales@heg.ch) dans la bdd Redis pour toutes les destinations où se trouve un hôtel <nomHotel>
        MongoCollection coll = Bdd.mongo.getCollection("Voyage");
        MongoCursor<Document> cursor = coll.find(Filters.in("nuitees.nom", nomHotel)).cursor();
        while (cursor.hasNext()) {
            Document doc = cursor.next();
            String dest = (String) doc.get("destination");
            String destCode = (String) doc.get("code");
            System.out.println("Hôtel " + nomHotel + " existe à " + dest);
            jedis.sadd(destCode, "dg@heg.ch");
            System.out.println("     "+destCode+ " : " +jedis.smembers(destCode.toString()));
        }
    }
}