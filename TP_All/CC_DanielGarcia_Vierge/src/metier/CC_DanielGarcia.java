package metier;


import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.neo4j.driver.*;
import org.neo4j.driver.Record;
import redis.clients.jedis.Jedis;

import java.util.logging.Level;
import java.util.logging.Logger;


public class CC_DanielGarcia {

    public CC_DanielGarcia() {
        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);

        // Connexion à la session de la bdd Redis
        Jedis bddJedis = new Jedis("localhost", 6379);
        bddJedis.flushAll();
        bddJedis.set("test", "testRedisOK");
        String strTestRedis= bddJedis.get("test");
        System.out.println(strTestRedis);

        // Connexion à la session de la bdd MongoDB
        // MongoDatabase bddMongo = MongoClients.create("mongodb+srv://daniel:194548@cluster0.uej3ssw.mongodb.net/").getDatabase("heg");
        MongoDatabase bddMongo = MongoClients.create("mongodb://localhost").getDatabase("revision");
        MongoCollection collectionTest = bddMongo.getCollection("test");
        collectionTest.drop();
        collectionTest.insertOne(new Document("test", "testMongoOK"));
        Document docTestMongo = (Document) collectionTest.find(Filters.eq("test", "testMongoOK")).first();
        String strTestMongo = (String) docTestMongo.get("test");
        System.out.println(strTestMongo);

        // Connexion à la session de la bdd Neo4J
        //Session bddNeo4j = GraphDatabase.driver("neo4j+s://29e3d736.databases.neo4j.io:7687", AuthTokens.basic("neo4j","19454848")).session();
        Session bddNeo4j = GraphDatabase.driver("bolt://localHost:7687", AuthTokens.basic("neo4j","19454848")).session();
        bddNeo4j.run("match (n) detach delete n");
        bddNeo4j.run("create (t:Test{test:\"testNeo4jOK\"}) return t");
        Result resTestNeo4j = bddNeo4j.run("match (n) return (n)");
        Record recTestNeo4j = (Record) resTestNeo4j.next();
        String strTestNeo4j = String.valueOf(recTestNeo4j.get("n").asNode().get("test"));
        System.out.println(strTestNeo4j);
    }

}
