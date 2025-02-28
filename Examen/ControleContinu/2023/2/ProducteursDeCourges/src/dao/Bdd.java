package dao;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;
import redis.clients.jedis.Jedis;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Bdd {
    // TODO: indiquez vos url de connexion ainsi que le mot de passe de votre base Neo4j
    private static final String URL_MONGO = "mongodb://localhost";
    private static final String URL_NEO4J = "bolt://localhost:7687";
    private static final String PWD_NEO4J = "19454848";

    private static final String URL_ORACLE = "jdbc:oracle:thin:@localhost:1521:xe";
    //private static final String URL_ORACLE = "jdbc:oracle:thin:@localhost:1521:xe:system;manager";

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!           NE MODIFIEZ PAS LE CODE DE CETTE CLASSE           !!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    public static Jedis jedis = null;
    public static MongoDatabase mongo = null;
    public static Session neo4j = null;
    public static Connection oracle = null;
    static {
        try {
            Connection oracle = DriverManager.getConnection(URL_ORACLE, "system", "194548");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void connect() {
        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);
        jedis = new Jedis();
        mongo = MongoClients.create(URL_MONGO).getDatabase("Courges");
        neo4j = GraphDatabase.driver(URL_NEO4J, AuthTokens.basic("neo4j", PWD_NEO4J)).session();

        String[] t1 = {"Merisier","Noyer","Olivier","Poirier","Pommier","Prunier","CC","BDD"};
        Map<String,String>[] t2 = new Map[]{ Map.of("Potimarron", "22", "Spaghetti", "44"), Map.of("Butternut", "33", "Muscade", "22", "Potimarron", "11", "Potiron", "77", "Spaghetti", "33"), Map.of("Potiron", "88"), Map.of("Butternut", "55", "Potimarron", "44", "Potiron", "77", "Spaghetti", "44"), Map.of("Muscade", "33", "Spaghetti", "88"), Map.of("Potimarron", "66", "Potiron", "99", "Spaghetti", "77"), Map.of("BDD NoSQL", "14/12/2023", "Auteur", "Ch. Stettler", "Sujet", "Producteurs de courges"), Map.of("62-31", "Gestion avancee des donnees")};
        String[] t3 = {"CC","14/12/2023","62-31","BDD NoSql","Auteur","Ch. Stettler","Sujet","Producteurs de courges","Donnees","Courges,Producteur,Magasin"};
        String[] t4 = {"{'nom':'Merisier','lieu':'Carouge','stat':[{'annee':2020,'nb':444},{'annee':2021,'nb':555},{'annee':2022,'nb':333}]}", "{'nom':'Noyer',  'lieu':'Veyrier','stat':[{'annee':2021,'nb':666},{'annee':2022,'nb':777}]}", "{'nom':'Olivier','lieu':'Troinex','stat':[{'annee':2020,'nb':555}]}", "{'nom':'Poirier','lieu':'Carouge','stat':[{'annee':2020,'nb':777},{'annee':2021,'nb':555},{'annee':2022,'nb':999}]}", "{'nom':'Pommier','lieu':'Carouge','stat':[{'annee':2021,'nb':222},{'annee':2022,'nb':444}]}", "{'nom':'Prunier','lieu':'Carouge','stat':[{'annee':2021,'nb':888},{'annee':2022,'nb':444}]}"};
        String[] t5 = {"c1","Courge","Butternut","c2","Courge","Muscade","c3","Courge","Potimarron","c4","Courge","Potiron","c5","Courge","Spaghetti","m1","Magasin","Migros","m2","Magasin","Coop","m3","Magasin","Denner","m4","Magasin","Lidl","m5","Magasin","Manor","p1","Producteur","Merisier","p2","Producteur","Noyer","p3","Producteur","Olivier","p4","Producteur","Poirier","p5","Producteur","Pommier","p6","Producteur","Prunier"};
        String[] t6 = {"p1","C","c3","p1","C","c5","p2","C","c1","p2","C","c2","p2","C","c3","p2","C","c4","p2","C","c5","p3","C","c4","p4","C","c1","p4","C","c3","p4","C","c4","p4","C","c5","p5","C","c2","p5","C","c5","p6","C","c3","p6","C","c4","p6","C","c5" , "p1","F","m2","p2","F","m3","p3","F","m1","p3","F","m4","p3","F","m5","p4","F","m1","p4","F","m2","p5","F","m2","p6","F","m5" , "m1","T","m3","m3","T","m1","m1","T","m5","m4","T","m5","m5","T","m4" };
        String[] t7 = {"p1","C","c2","2020","p1","C","c2","2021","p1","C","c4","2021","p1","C","c2","2022","p1","C","c3","2022","p1","C","c5","2022","p2","C","c2","2021","p2","C","c4","2021","p2","C","c1","2022","p3","C","c2","2020","p3","C","c3","2020","p3","C","c4","2020","p4","C","c1","2020","p4","C","c4","2020","p4","C","c2","2021","p4","C","c3","2022","p4","C","c4","2022","p5","C","c3","2021","p5","C","c5","2021","p5","C","c1","2022","p5","C","c4","2022","p6","C","c1","2021","p6","C","c3","2021","p6","C","c3","2022","p6","C","c4","2022","p6","C","c5","2022"};

        jedis.flushAll(); for (int i=0; i<t1.length; i++) { jedis.hmset(t1[i], t2[i]); } jedis.mset(t3);
        MongoCollection coll = mongo.getCollection("Producteurs"); coll.drop(); for (int i=0; i<t4.length; i++) { coll.insertOne(Document.parse(t4[i])); }
        neo4j.run("MATCH (n) DETACH DELETE n"); String s = "CREATE ("+t5[0]+":"+t5[1]+"{nom:'"+t5[2]+"'})"; for (int i=3; i<t5.length;i+=3) { s+=",("+t5[i]+":"+t5[i+1]+"{nom:'"+t5[i+2]+"'})"; } for (int i=0; i<t6.length;i+=3) { s+=",("+t6[i]+")-[:"+(t6[i+1].equals("C")?"CULTIVE":t6[i+1].equals("V")?"VEND":t6[i+1].equals("F")?"FOURNIT":"TRANSFERT")+"]->("+t6[i+2]+")"; } for (int i=0; i<t7.length;i+=4) { s+=",("+t7[i]+")-[:"+(t7[i+1].equals("C")?"CULTIVE":t7[i+1].equals("V")?"VEND":t7[i+1].equals("F")?"FOURNIT":"TRANSFERT")+"{annee:"+t7[i+3]+"}]->("+t7[i+2]+")"; } neo4j.run(s);
    }
}