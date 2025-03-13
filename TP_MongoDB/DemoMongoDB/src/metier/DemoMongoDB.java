package metier;

import com.google.gson.Gson;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import domaine.Prof;
import org.bson.Document;

import java.util.logging.Level;
import java.util.logging.Logger;

public class DemoMongoDB {
    public DemoMongoDB() {
        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);
        MongoDatabase bdd = MongoClients.create("mongodb+srv://daniel:194548@cluster0.uej3ssw.mongodb.net/").getDatabase("heg");
        MongoCollection coll = bdd.getCollection("Prof");

        Prof prof1 = new Prof("Stettler", "Christian", "IG");
        Prof prof2 = new Prof("Leclère", "Desi", "IG");
        Prof prof3 = new Prof("Billard", "David", "IG");
        Prof prof4 = new Prof("Trabix", "Alex", "IG");

        // Convertir un Prof dans un Document (sans récupérer tous les champs à la main ?)
        //Document doc = new Document("nom",prof.getNom()).append("prenom",prof.getPrenom()).append("filiere",prof.getFiliere());
        Document docProf1 = Document.parse(new Gson().toJson(prof1));
        Document docProf2 = Document.parse(new Gson().toJson(prof2));
        Document docProf3 = Document.parse(new Gson().toJson(prof3));
        Document docProf4 = Document.parse(new Gson().toJson(prof4));

        coll.drop();
        coll.insertOne(docProf1);
        coll.insertOne(docProf2);
        coll.insertOne(docProf3);
        coll.insertOne(docProf4);

        MongoCursor curseur = coll.find().cursor();
        while (curseur.hasNext()) {
            Document docProf = (Document) curseur.next();
            Prof prof = new Gson().fromJson(docProf.toJson(), Prof.class);
            System.out.println(prof.toString());
        }
    }
}