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
        creerLesVoyagesPour("bdd@heg.ch");
        autresTransportsPossiblesPour("LUX");
        modifierLesTransports("AVION", "KLM", "AVION", "AirFrance");
        modifierLesTransports("CAR", "Helvecie", "TRAIN", "CFF");
        ajouterVoyage("AMS", "Amsterdam", "Royal", "Imperial", "5*");
        sInscrireAuxVoyagesSelonNomHotel("Royal");
    }

    private void creerLesVoyagesPour(String email) {
        List<Voyage> voyages = new ArrayList<>();
        // TODO: Créez des instances de la classe Voyage pour chaque destination à laquelle <email> s'est inscrit (dans Redis),
        //       supprimez ces inscriptions de Redis (ôtez son email des listes)
        //       puis affichez l'ArrayList voyages (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)

        System.out.println("Liste des voyages où " + email + " est inscrit :");
        for (Voyage v : voyages) System.out.println(v);  // l'affichage de tous les voyages pour <email> doit se faire ici
    }

    private void autresTransportsPossiblesPour(String code) {
        // TODO: Affichez les autres transports à destination de <code> qui ne partent pas du :Départ standard
        System.out.println("Autres transports à destination de " + code + " qui ne partent pas du Départ standard :");
        Result res = neo4j.run("match (d:Destination)-[t]->(a{code:'LUX'})  return type(t) as type, t.compagnie as compagnie, d.ville as ville");
        // ou bien match (d)-[t]->(a) where d.ville<>'Geneve' and a.code='LUX' return d,t,a
        while (res.hasNext()) {
            Record rec = res.next();
            System.out.println("en " + rec.get("type") + " (" + rec.get("compagnie") + ") via " + rec.get("ville"));
            }
        System.out.println();
    }

    private void modifierLesTransports(String ancienType, String ancienneCompagnie, String nouveauType, String nouvelleCompagnie) {
        // TODO: Tous les transports de <ancienType> qui étaient effectués par l'<ancienneCompagnie> sont remplacés par les nouvelles données :
        Result res = neo4j.run("MATCH (a)-[t]->(c) where type(t) = '"+ancienType+"' and t."+ancienneCompagnie+" = 'Swisss' create (a)-[tt:"+nouveauType+"{compagnie:'"+nouvelleCompagnie+"'}]->(c) delete t return type(tt) as type, tt.compagnie as compagnie");
        while(res.hasNext()){
            Record rec = res.next();
        }
    }

    private void ajouterVoyage(String code, String destination, String nomHotel1, String nomHotel2, String cat) {
        // TODO: Ajoutez un nouveau voyage à destination de <code> dans lequel se trouve les 2 hôtels spécifiés
        Nuitee n1 = new Nuitee(nomHotel1);
        Nuitee n2 = new Nuitee(nomHotel2, cat);
        String js1 = new Gson().toJson(n1);
        String js2 = new Gson().toJson(n2);
        Document doc1 = Document.parse(js1);
        Document doc2 = Document.parse(js2);
        MongoCollection collVoyage = mongo.getCollection("Voyage");
        collVoyage.insertOne(new Document("code", code).append("destination", destination).append("nuitees", Arrays.asList(doc1, doc2)));
    }

    private void sInscrireAuxVoyagesSelonNomHotel(String nomHotel) {
        // TODO: Inscrivez-vous (rajoutez vos initiales@heg.ch) dans la bdd Redis pour toutes les destinations où se trouve un hôtel <nomHotel>

        final String MON_EMAIL = "dg@heg.ch";
        MongoCollection coll = mongo.getCollection("Voyage");
        MongoCursor curs = coll.find(Filters.eq("nuitees.nom", nomHotel)).cursor();
        while (curs.hasNext()) {
            Document doc = (Document)curs.next();
            String dest =  (String) doc.get("destination");
            System.out.println("Hôtel " + nomHotel + " existe à " + dest);
            jedis.sadd(doc.get("code").toString(), MON_EMAIL);
        }
    }
}