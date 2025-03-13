package metier;

import com.google.gson.Gson;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import static dao.Bdd.jedis;
import static dao.Bdd.neo4j;
import static dao.Bdd.mongo;
public class ListeDeVoyages {
    public ListeDeVoyages() {

        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)

        afficherLesDonneesJedis();
        afficherLesDonneesMongo();
        afficherLesDonneesNeo4j();

        creerLesVoyagesPour("bdd@heg.ch");
        autresTransportsPossiblesPour("LUX");
        modifierLesTransports("AVION", "KLM", "AVION", "AirFrance");
        modifierLesTransports("CAR", "Helvecie", "TRAIN", "CFF");
        ajouterVoyage("AMS", "Amsterdam", "Royal", "Imperial", "5*");
        sInscrireAuxVoyagesSelonNomHotel("Royal");
    }
    private void creerLesVoyagesPour(String email) {
        System.out.println();
        System.out.println("Execrcice 1 :");
        List<Voyage> voyages = new ArrayList<>();
        // TODO: Créez des instances de la classe Voyage pour chaque destination à laquelle <email> s'est inscrit (dans Redis),
        //       supprimez ces inscriptions de Redis (ôtez son email des listes)
        //       puis affichez l'ArrayList voyages (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)
        Set<String> codeDest = jedis.smembers("DESTINATIONS");
        for (String code : codeDest) {
            if(jedis.sismember(code, email)){
                ArrayList<Transport> transports = new ArrayList<>();
                ArrayList<Nuitee> nuitees = new ArrayList<>();
                MongoCursor cursDest = mongo.getCollection("Voyage").find(Filters.eq("code",code)).cursor();
                while(cursDest.hasNext()) {
                    Document doc = (Document) cursDest.next();
                    ArrayList<Document> nuiteesList= (ArrayList<Document>) doc.getList("nuitees", Document.class);
                    for (Document nuit : nuiteesList) {
                        Nuitee n = new Nuitee(nuit.getString("nom"), nuit.getString("cat"));
                        nuitees.add(n);
                    }
                    Result res = neo4j.run("match(d)-[t]->(a{code:'"+doc.get("code")+"'}) return type(t) as type, t.compagnie as compagnie ");
                    while(res.hasNext()){
                        Record rec = res.next();
                        Transport t = new Transport(rec.get("type").toString(), rec.get("compagnie").toString());
                        transports.add(t);
                    }
                    Voyage voyage = new Voyage(email, doc.get("code").toString(), doc.get("destination").toString(), nuitees, transports);
                    voyages.add(voyage);
                }
            }
            jedis.srem(code, email);
        }
        System.out.println("Liste des voyages où " + email + " est inscrit :");
        for (Voyage v : voyages) System.out.println(v);  // l'affichage de tous les voyages pour <email> doit se faire ici
        // afficherLesDonneesJedis(); // Pour vérifier les suppressions
    }
    private void autresTransportsPossiblesPour(String code) {
        System.out.println();
        System.out.println("Execrcice 2 :");
        // TODO: Affichez les autres transports à destination de <code> qui ne partent pas du :Départ standard
        System.out.println("Autres transports à destination de " + code + " qui ne partent pas du Départ standard :");
        Result res = neo4j.run("match (d:Destination)-[t]->(a:Destination{code:'"+code+"'})  return d,t,a,type(t) as typ");
        // ou bien match (d)-[t]->(a) where d.ville<>'Geneve' and a.code='LUX' return d,t,a
        while (res.hasNext()) {
            Record rec = res.next();
            System.out.println("Le voyage en "+rec.get("typ")+" par "+rec.get("t").get("compagnie")+" à destination de "+rec.get("d").get("ville")+"("+rec.get("d").get("code")+") depuis "+ rec.get("a").get("ville")+"("+rec.get("a").get("code")+")");
        }
    }
    private void modifierLesTransports(String ancienType, String ancienneCompagnie, String nouveauType, String nouvelleCompagnie) {
        System.out.println();
        System.out.println("Execrcice 3 :");
        // TODO: Tous les transports de <ancienType> qui étaient effectués par l'<ancienneCompagnie> sont remplacés par les nouvelles données :
        //       <nouveauType> et <nouvelleCompagnie>
        System.out.println("Tous les transports de " + ancienType + " qui étaient effectués par l'" + ancienneCompagnie + " sont remplacés par les nouvelles données :");
        Result res = neo4j.run("match (d)-[t:"+ancienType+"{compagnie:'"+ancienneCompagnie+"'}]->(a) create (d)-[tt:"+nouveauType+"{compagnie:'"+nouvelleCompagnie+"'}]->(a) delete t return d,a,tt, type(tt) as ttyp, type(t) as typ");
        while (res.hasNext()) {
            Record rec = res.next();
            System.out.println("Le voyage en "+ancienType+" effectué par "+ancienneCompagnie+" à destination de "+rec.get("a").get("ville")+"("+rec.get("a").get("code")+") depuis "+ rec.get("d").get("ville")+"("+rec.get("d").get("code")+") a été remplacée par un voyage en "+nouveauType+" par "+nouvelleCompagnie);
        }
    }
    private void ajouterVoyage(String code, String destination, String nomHotel1, String nomHotel2, String cat) {
        System.out.println();
        System.out.println("Execrcice 4 :");
        // TODO: Ajoutez un nouveau voyage à destination de <code> dans lequel se trouve les 2 hôtels spécifiés
        System.out.println("Ajoutez un nouveau voyage à destination de " + code + " dans lequel se trouve les 2 hôtels spécifiés :");
        MongoCollection collVoyage = Bdd.mongo.getCollection("Voyage");
        collVoyage.insertOne(new Document("code", code).append("destination", destination).append("nuitees", Arrays.asList(new Document("nom", nomHotel1).append("cat", cat), new Document("nom", nomHotel2).append("cat", cat))));
        Document doc = (Document) collVoyage.find(new Document("code", code)).first();
        ArrayList<Document> nuitees = (ArrayList<Document>) doc.get("nuitees");
        System.out.println("Le voyage à destination de "+doc.get("code")+" a été ajouté avec les "+nuitees.size()+" hôtels suivants :");
        for(Document h : nuitees){
            System.out.println("    "+h.get("nom")+" ("+h.get("cat")+")");
        }
    }
    private void sInscrireAuxVoyagesSelonNomHotel(String nomHotel) {
        System.out.println();
        System.out.println("Execrcice 5 :");
        // TODO: Inscrivez-vous (rajoutez vos initiales@heg.ch) dans la bdd Redis pour toutes les destinations où se trouve un hôtel <nomHotel>
        final String MON_EMAIL = "dg@heg.ch";
        //MongoCursor cursDest = mongo.getCollection("Voyage").find(new Document("nuitees", new Document("$elemMatch", new Document("nom", nomHotel)))).cursor();
        MongoCursor cursDest = mongo.getCollection("Voyage").find(Filters.eq("nuitees.nom",nomHotel)).cursor();
        while(cursDest.hasNext()) {
            Document doc = (Document) cursDest.next();
            System.out.println("Hôtel " + nomHotel + " existe à " + doc.get("destination")+ " ("+ doc.get("code")+")");
            jedis.sadd(doc.get("code").toString(), MON_EMAIL);
            System.out.println("  => "+MON_EMAIL+" a été inscrit à la destination "+doc.get("destination")+ " ("+ doc.get("code")+")");
            System.out.println("     Vérification dans la base Redis :");
            System.out.println("     "+doc.get("code")+ " : " +jedis.smembers(doc.get("code").toString()));
        }
    }
    private void afficherLesDonneesJedis() {
        System.out.println();
        System.out.println("Donnée dans Jedis :");
        System.out.println("-------------------");
        Set<String> keys = jedis.keys("*");
        for (String key : keys) {
            System.out.println("Clé : " + key + " | Valeur : " + jedis.smembers(key));
        }
    }
    private void afficherLesDonneesMongo() {
        System.out.println();
        System.out.println("Donnée dans MongoDB :");
        System.out.println("---------------------");
        MongoCollection coll = mongo.getCollection("Voyage");
        MongoCursor cursDest = coll.find().cursor();
        while (cursDest.hasNext()) {
            System.out.println("---------------------");
            Document doc = (Document) cursDest.next();
            System.out.println("Code : " + doc.get("code") + " | Destination : " + doc.get("destination"));
            List<Document> listNuitees = (List<Document>) doc.get("nuitees");
            System.out.println("Liste des nuitees : ");
            for (int n = 0; n < listNuitees.size(); n++) {
                System.out.println("   " + listNuitees.get(n).get("nom") + " | " + listNuitees.get(n).get("cat"));
            }
        }
    }
    private void afficherLesDonneesNeo4j() {
        System.out.println();
        System.out.println("Donnée dans Neo4j :");
        System.out.println("-------------------");
        Result res = neo4j.run("MATCH (d:Depart)-[r]->(a:Destination) RETURN d,r,a,type(r) as type");
        while (res.hasNext()){
            System.out.println("-------------------");
            Record rec = res.next();
            System.out.println("DEPART      : Code : "+rec.get("d").get("code")+" | Ville : "+rec.get("d").get("ville"));
            System.out.println("DESTINATION : Code : "+rec.get("a").get("code")+" | Ville : "+rec.get("a").get("ville"));
            System.out.println("TRANSPORT   : Type : "+rec.get("type")+" | Compagnie : "+rec.get("r").get("compagnie"));
        }
        System.out.println("----------------------------------------------------");
        System.out.println("----------------------------------------------------");
        System.out.println();
    }
}