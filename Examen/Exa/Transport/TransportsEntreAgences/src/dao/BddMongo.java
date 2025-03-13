package dao;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BddMongo {
    private MongoDatabase db;
    public BddMongo() { Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE); }
    public MongoDatabase connect() { db = MongoClients.create("mongodb://localhost").getDatabase("ExaHEG"); chargerDonnees(); return db; }
    private void chargerDonnees() {

        db.getCollection("Agence").drop();
        db.getCollection("Agence").insertMany(new ArrayList<>() {
            { add(new Document("no",1).append("nom","Carouge"));
                add(new Document("no",2).append("nom","Bernex"));
                add(new Document("no",3).append("nom","Corsier"));
                add(new Document("no",4).append("nom","Meyrin"));
                add(new Document("no",5).append("nom","Lancy")); }});
    }
}