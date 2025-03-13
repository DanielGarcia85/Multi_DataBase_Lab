package metier;

import com.google.gson.Gson;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import domain.Employe;
import org.bson.Document;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DemoMongoDB {
    public DemoMongoDB(){
        //Pour limiter les logs
        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);
        //Description
        System.out.println();
        System.out.println("==> Démonstration de MongoDB");
        System.out.println("----------------------------");

        //1) Connection à la base de donnée
        MongoDatabase bdd = MongoClients.create("mongodb://localhost").getDatabase("mybddmongo");

        //2) On récupère une collection (=~ table SQL) (Il crée la collection si elle n'existe pas)
        MongoCollection coll1 = bdd.getCollection("Employes");

        //3) On travaille sur cette collection coll1
        //D'abord on la vide, on supprime tous les documents
        coll1.drop();
        //insertion de documents
        coll1.insertOne(new Document("nom", "Dupond").append("prenom", "Paul"));
        coll1.insertOne(new Document("nom", "Durand").append("prenom", "Pierre").append("salaire", 5000));
        coll1.insertOne(new Document("nom", "Dufour").append("prenom", "Jack").append("salaire", 5000));
        coll1.insertOne(new Document("nom", "Durand").append("prenom", "Mike").append("salaire", 6000).append("dept", "RH"));
        coll1.insertOne(new Document("nom", "Durand").append("prenom", "Steve").append("salaire", 7000).append("dept", "IT"));
        coll1.insertOne(new Document("nom", "Dumond").append("prenom", "Carter").append("salaire", 8000).append("dept", "Vente"));
        coll1.insertOne(new Document("nom", "Dugland").append("prenom", "Joe").append("salaire", 9000).append("dept", "RH").append("tel", "0799999999"));
        coll1.insertOne(new Document("_id", "55").append("nom", "Dumond").append("prenom", "Jack").append("salaire", 9000).append("dept", "IT").append("tel", "0799999999"));
        coll1.insertOne(new Document("nom", "Duracel").append("prenom", "Charles").append("salaire", 5000).append("dept", "IT").append("tel", "0799999999").append("_id", "33"));
        // En général, on se préocuppe pas de _id. Car il le crée tout seul. Et on va pas l'utiliser pour récuprer nos document (contrairement à Redis)
        // Ne pas insérer de _id, car sinon après ça peut compliquer. Ex. on peut pas mettre das un array list et renvoyer dan une collection


        System.out.println();
        System.out.println("==> Affiche le 1er enregistrement (document) de la collection coll1");
        System.out.println("-------------------------------------------------------------------");
        System.out.println(coll1.find().first());
        System.out.println(coll1.find().first());


        // On a trois méthode pour récupèrer les data
        // A. First
        System.out.println();
        System.out.println("==> Affiche le 1er Document de la collection coll1");
        System.out.println("--------------------------------------------------");
        Document doc1 = (Document) coll1.find().first(); // recupère qu'un seul document (le 1er)
        System.out.println(doc1);

        // B. Cursor
        System.out.println();
        System.out.println("==> Parcourir et afficher le contenu d'un MongoCursor");
        System.out.println("-----------------------------------------------------");
        MongoCursor curs1 = coll1.find().cursor(); // fournit un MongoCursor à parcourir
        while (curs1.hasNext()){
            System.out.println(curs1.next());
            //Document doci = (Document) curs1.next();
        }

        // C. Into
        System.out.println();
        System.out.println("==> ArrayList");
        System.out.println("-------------");
        ArrayList arr1 = (ArrayList) coll1.find().into(new ArrayList()); // Permet de stocker tous les documents dans une Collection Java (ArrayList, HashSet)
        System.out.println(arr1.size());
        System.out.println(arr1.getFirst());
        System.out.println(arr1.isEmpty());
        System.out.println(arr1.removeFirst());
        System.out.println(arr1.size());
        System.out.println(arr1.getFirst());
        System.out.println(arr1.size());
        for(int i=0; i < arr1.size(); i++){
            System.out.println(arr1.get(i));
        }
        System.out.println();
        System.out.println(arr1);

        System.out.println();
        System.out.println(" => Employés 2");
        System.out.println("--------------");
        MongoCollection coll2 = bdd.getCollection("Employes2");
        coll2.drop();
        coll2.insertMany(arr1);
        System.out.println(coll2.find().first());
        ArrayList arr2 = (ArrayList) coll2.find().into(new ArrayList());
        for(int i=0; i < arr2.size(); i++){
            System.out.println(arr2.get(i));
        }

        // Exploration des Find et Filter
        System.out.println();
        System.out.println("==> Divers Filtre sur le Find");
        System.out.println("---------------");
        System.out.println("--- Filtre .gte (le 1er qui est plus grand que)");
        System.out.println(coll2.find(Filters.gte("salaire", 5500)).first());
        System.out.println("--- Filtre .in");
        System.out.println(coll2.find(Filters.in("salaire", 5000, 7000, 9000)).into(new ArrayList()));
        System.out.println("--- Filtre .in");
        ArrayList arr22 = (ArrayList) coll2.find(Filters.in("salaire", 5000, 7000, 9000)).into(new ArrayList());
        for(int i=0; i<arr22.size(); i++){
            System.out.println(arr22.get(i));
        }
        System.out.println("--- Filtre .eq");
        System.out.println(coll2.find(Filters.eq("nom","Durand")).first());

        //           - Convertir les Document retournés en classe Java (new Employe(), ou new Personne,...)


        System.out.println();
        System.out.println("==> Gson");
        System.out.println("--------");

        MongoCollection coll3 = bdd.getCollection("Employes3");
        coll3.drop();
        coll3.insertOne(new Document("nom", "Durand").append("prenom", "Mike").append("salaire", 6000).append("dept", "RH"));
        coll3.insertOne(new Document("nom", "Durand").append("prenom", "Steve").append("salaire", 7000).append("dept", "IT"));
        coll3.insertOne(new Document("nom", "Dumond").append("prenom", "Carter").append("salaire", 8000).append("dept", "Vente"));
        coll3.insertOne(new Document("nom", "Dumou").append("prenom", "Hank").append("salaire", 5000).append("dept", "Vente").append("tel", "0799999999"));
        coll3.insertOne(new Document("nom", "Dupond").append("prenom", "Marc").append("salaire", 5000));


        MongoCursor curs3 = coll3.find().cursor(); // fournit un MongoCursor à parcourir
        while (curs3.hasNext()){
            Object obj = curs3.next(); //cet objet contient un org.bson.document
            Document doc3 = (Document) obj;
            // ou bien
            // Document doc3 = (Document) curs2.next();

            System.out.println(doc3);
            System.out.println(doc3.toJson());
            String str1 = new Gson().toJson(doc3);
            System.out.println(str1);

            System.out.println("-");
            Employe empl = new Employe((String) doc3.get("nom"), (String) doc3.get("prenom"), (Integer) doc3.get("salaire"), (String) doc3.get("dept"));
            empl.print();

            System.out.println("-");
            Employe empl2 = new Gson().fromJson(str1, Employe.class);
            empl2.print();
            Employe empl3 = new Gson().fromJson(doc3.toJson(), Employe.class);
            System.out.println("-");
            empl3.print();

            System.out.println("-");
            System.out.println(empl2.toString()); // Test
            System.out.println("----");
        }

        //Penser à gérer les exceptions dans des try catch => si catch on ne traite pas
    }
}
