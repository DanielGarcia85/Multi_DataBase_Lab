package metier;

import com.google.gson.Gson;
import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import domaine.Garage;
import domaine.Personne;
import domaine.Voiture;
import org.bson.Document;
import org.neo4j.driver.*;
import org.neo4j.driver.Record;
import redis.clients.jedis.Jedis;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
public class TP_Rev {

    public TP_Rev() {
        //Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);

        // Connexion à la session de la bdd Redis
        Jedis bddJedis = new Jedis("localhost", 6379);
        bddJedis.flushAll();
        bddJedis.set("test", "testRedisOK");
        String strTestRedis= bddJedis.get("test");
        System.out.println(strTestRedis);
        bddJedis.flushAll();

        // Connexion à la session de la bdd MongoDB
        //MongoDatabase bddMongo = MongoClients.create("mongodb+srv://daniel:194548@cluster0.uej3ssw.mongodb.net/").getDatabase("heg");
        MongoDatabase bddMongo = MongoClients.create("mongodb://localhost").getDatabase("revision");
        MongoCollection collectionTest = bddMongo.getCollection("test");
        collectionTest.drop();
        collectionTest.insertOne(new Document("test", "testMongoOK"));
        Document docTestMongo = (Document) collectionTest.find(Filters.eq("test", "testMongoOK")).first();
        String strTestMongo = (String) docTestMongo.get("test");
        System.out.println(strTestMongo);
        collectionTest.drop();

        // Connexion à la session de la bdd Neo4J
        //Session bddNeo4j = GraphDatabase.driver("neo4j+s://29e3d736.databases.neo4j.io:7687", AuthTokens.basic("neo4j","19454848")).session();
        Session bddNeo4j = GraphDatabase.driver("bolt://localHost:7687", AuthTokens.basic("neo4j","19454848")).session();
        bddNeo4j.run("match (n) detach delete n");
        bddNeo4j.run("create (t:Test{test:\"testNeo4jOK\"}) return t");
        Result resTestNeo4j = bddNeo4j.run("match (n) return (n)");
        Record recTestNeo4j = (Record) resTestNeo4j.next();
        String strTestNeo4j = String.valueOf(recTestNeo4j.get("n").asNode().get("test"));
        System.out.println(strTestNeo4j);
        bddNeo4j.run("match (n) detach delete n");

        System.out.println("--------------------------------------------------");
        System.out.println();

        // Creation des Objets
        BddObject bdd = new BddObject();
        Voiture v1 = bdd.getV1(); Voiture v2 = bdd.getV2(); Voiture v3 = bdd.getV3(); Voiture v4 = bdd.getV4(); Voiture v5 = bdd.getV5(); Voiture v6 = bdd.getV6(); Voiture v7 = bdd.getV7();
        Personne p1 = bdd.getP1(); Personne p2 = bdd.getP2(); Personne p3 = bdd.getP3(); Personne p4 = bdd.getP4(); Personne p5 = bdd.getP5(); Personne p6 = bdd.getP6(); Personne p7 = bdd.getP7();
        Garage g1 = bdd.getG1(); Garage g2 = bdd.getG2(); Garage g3 = bdd.getG3(); Garage g4 = bdd.getG4(); Garage g5 = bdd.getG5();

        // Creer une liste de Document de Voiture
        String jsStrV1 = new Gson().toJson(v1); String jsStrV2 = new Gson().toJson(v2); String jsStrV3 = new Gson().toJson(v3); String jsStrV4 = new Gson().toJson(v4); String jsStrV5 = new Gson().toJson(v5); String jsStrV6 = new Gson().toJson(v6); String jsStrV7 = new Gson().toJson(v7);
        Document docV1 = Document.parse(jsStrV1); Document docV2 = Document.parse(jsStrV2); Document docV3 = Document.parse(jsStrV3); Document docV4 = Document.parse(jsStrV4); Document docV5 = Document.parse(jsStrV5); Document docV6 = Document.parse(jsStrV6); Document docV7 = Document.parse(jsStrV7);
        List listV = new ArrayList<>();
        listV.add(docV1); listV.add(docV2); listV.add(docV3); listV.add(docV4); listV.add(docV5); listV.add(docV6); listV.add(docV7);

        // Creer une liste de Document de Personne
        String jsStrP1 = new Gson().toJson(p1); String jsStrP2 = new Gson().toJson(p2); String jsStrP3 = new Gson().toJson(p3); String jsStrP4 = new Gson().toJson(p4); String jsStrP5 = new Gson().toJson(p5); String jsStrP6 = new Gson().toJson(p6); String jsStrP7 = new Gson().toJson(p7);
        Document docP1 = Document.parse(jsStrP1); Document docP2 = Document.parse(jsStrP2); Document docP3 = Document.parse(jsStrP3); Document docP4 = Document.parse(jsStrP4); Document docP5 = Document.parse(jsStrP5); Document docP6 = Document.parse(jsStrP6); Document docP7 = Document.parse(jsStrP7);
        List listP = new ArrayList<>();
        listP.add(docP1); listP.add(docP2); listP.add(docP3); listP.add(docP4); listP.add(docP5); listP.add(docP6); listP.add(docP7);

        // Creer une liste de Document de Garage
        String jsStrG1 = new Gson().toJson(g1); String jsStrG2 = new Gson().toJson(g2); String jsStrG3 = new Gson().toJson(g3); String jsStrG4 = new Gson().toJson(g4); String jsStrG5 = new Gson().toJson(g5);
        Document docG1 = Document.parse(jsStrG1); Document docG2 = Document.parse(jsStrG2); Document docG3 = Document.parse(jsStrG3); Document docG4 = Document.parse(jsStrG4); Document docG5 = Document.parse(jsStrG5);
        List listG = new ArrayList<>();
        listG.add(docG1); listG.add(docG2); listG.add(docG3); listG.add(docG4); listG.add(docG5);

        MongoCollection collectionVoitures = bddMongo.getCollection("voitures");
        MongoCollection collectionPersonnes = bddMongo.getCollection("personnes");
        MongoCollection collectionGarages = bddMongo.getCollection("garages");
        collectionVoitures.drop();
        collectionPersonnes.drop();
        collectionGarages.drop();
        //collectionVoitures.insertMany(listV);
        collectionVoitures.insertOne(docV1); collectionVoitures.insertOne(docV2); collectionVoitures.insertOne(docV3); collectionVoitures.insertOne(docV4); collectionVoitures.insertOne(docV5); collectionVoitures.insertOne(docV6); collectionVoitures.insertOne(docV7);
        //collectionPersonnes.insertMany(listP);
        collectionPersonnes.insertOne(docP1); collectionPersonnes.insertOne(docP2); collectionPersonnes.insertOne(docP3); collectionPersonnes.insertOne(docP4); collectionPersonnes.insertOne(docP5); collectionPersonnes.insertOne(docP6); collectionPersonnes.insertOne(docP7);
        //collectionGarages.insertMany(listG);
        collectionGarages.insertOne(docG1); collectionGarages.insertOne(docG2); collectionGarages.insertOne(docG3); collectionGarages.insertOne(docG4); collectionGarages.insertOne(docG5);

        MongoCursor cursorVoitures = collectionVoitures.find().cursor();
        MongoCursor cursorPersonnes = collectionPersonnes.find().cursor();
        MongoCursor cursorGarages = collectionGarages.find().cursor();

        // Inserstion des Voiture dans Redis et Neo4J depuis MongoDB + Test
        int i = 0;
        while(cursorVoitures.hasNext()){

            System.out.println("MongoDB : ");
            Document doc = (Document) cursorVoitures.next(); // créer le Document à partir du curseur
            System.out.println("  Document : \n" + "    " + doc);
            String jsStrVoit1 = doc.toJson(); // créer le String au format Json à partir du Document
            System.out.println("  Json du Document : \n" + "    " + jsStrVoit1);
            Voiture voit1 = new Gson().fromJson(jsStrVoit1, Voiture.class); // créer Voiture à partir du String au format Json
            System.out.println("  Voiture à partir de Json Document : \n" + "    " + voit1);
            String jsStrVoit2 = new Gson().toJson(voit1); // créer le String au format Json à partir de Voiture
            System.out.println("  Json à partir de Voiture : \n" + "    " + jsStrVoit2);
            Voiture voit2 = new Gson().fromJson(jsStrVoit2, Voiture.class);
            System.out.println("  Voiture à partir de Json Voiture : \n" + "    " + voit2);

            System.out.println("Redis : ");
            String ii = (String) Integer.toString(i);
            bddJedis.set(ii, jsStrVoit1); // insérer le String de Document au format Json dans la BDD Redis
            String strJedis1 = bddJedis.get(ii);
            System.out.println("  String Document de Jedis "+ ii +" : \n" + "    " + strJedis1 + " Type : " + bddJedis.type(ii));
            Voiture voit3 = new Gson().fromJson(strJedis1, Voiture.class); // créer Voiture à partir du String de Document au format Json
            System.out.println("  Voiture à partir de Json Document : \n" + "    " + voit3);
            i++;
            ii = (String) Integer.toString(i);
            bddJedis.set(ii, jsStrVoit2); // insérer le String de Voiture au format Json dans la BDD Redis
            String strJedis2 = bddJedis.get(ii);
            System.out.println("  String Voiture de Jedis "+ ii +" : \n" + "    " + strJedis2 + " Type : " + bddJedis.type(ii));
            Voiture voit4 = new Gson().fromJson(strJedis2, Voiture.class); // créer Voiture à partir du String de Voiture au format Json
            System.out.println("  Voiture à partir de Json Voiture : \n" + "    " + voit4);
            i++;

            System.out.println("Neo4J : ");
            bddNeo4j.run("create (v:Voiture{marque:'" + voit1.getMarque() + "',modele:'"+voit1.getModel()+"', annee:"+voit1.getAnnee()+"})");
            Result res = bddNeo4j.run("match(v:Voiture{marque:'" + voit1.getMarque() + "'}) return (v)");
            while (res.hasNext()){
                Record rec = res.next();
                System.out.println("Insertion du Record : Marque " + rec.get("v").get("marque") + ", Modele"+ rec.get("v").get("modele") + " de l'annnée "+ rec.get("v").get("annee"));
            }
            Result res2 = bddNeo4j.run("match(v:Voiture) return (v)");
            System.out.println("  Toutes d'un coup :");
            while (res2.hasNext()){
                Record rec2 = res2.next();
                System.out.println("  Record : Marque " + rec2.get("v").get("marque") + ", Modele "+ rec2.get("v").get("modele") + " de l'annnée "+ rec2.get("v").get("annee"));
            }

            System.out.println("---------");
        }


        // Inserstion des Personne et leur relation avec Voiture dans Neo4J depuis MongoD
        System.out.println();
        System.out.println("Insertion des Personnes dans Neo4j : ");
        while (cursorPersonnes.hasNext()){
            Document docPers = (Document) cursorPersonnes.next();
            Personne pers1 = new Gson().fromJson(docPers.toJson(), Personne.class);
            Result res3 = bddNeo4j.run("create (p:Personne{nom:'" + pers1.getNom()+ "', prenom:'" + pers1.getPrenom()+ "', annee:'" + pers1.getAnnee()+ "', voiture:'"+pers1.getVoiture().getMarque()+" "+pers1.getVoiture().getModel()+"'}) return p");
            Record rec3 = res3.next();
            System.out.println("Insertion de la Personne : " +rec3.get("p").get("prenom") +" "+rec3.get("p").get("nom")+" né en "+rec3.get("p").get("annee")+" conduit " + rec3.get("p").get("voiture"));
        }
        bddNeo4j.run("match (p:Personne), (v:Voiture) where p.voiture=v.marque+' '+v.modele create (p)-[:CONDUIT]->(v)");


        // Inserstion des Garage et leur relation avec Voiture dans Neo4J depuis MongoD
        System.out.println();
        System.out.println("Insertion des Garages dans Neo4j : ");
        while (cursorGarages.hasNext()){
            Document docGar = (Document) cursorGarages.next();
            Garage gar1 = new Gson().fromJson(docGar.toJson(), Garage.class);
            ArrayList<String> listVoit = new ArrayList();
            for(int ig=0; ig<gar1.getVoitures().length; ig++) {
                listVoit.add(gar1.getVoitures()[ig].getMarque() + " " + gar1.getVoitures()[ig].getModel());
            }
            bddNeo4j.run("create (g:Garage{personne:'" + gar1.getProprio().getNom() + "', nom:'" + gar1.getNom() + "', voitures:'" + listVoit + "'})");
            System.out.println("Insertion du Garage : "+ gar1.getNom() +" de "+gar1.getProprio().getNom());
            // Création des relations entre le Garage et les Voitures
            for (int ig = 0; ig < gar1.getVoitures().length; ig++) {
                bddNeo4j.run("MATCH (g:Garage {nom: '"+gar1.getNom()+"'}), (v:Voiture {marque: '"+gar1.getVoitures()[ig].getMarque()+"', modele: '"+gar1.getVoitures()[ig].getModel()+"'}) "+"CREATE (g)-[:POSSEDE]->(v)");
            }
        }


        System.out.println();
        System.out.println("Voici la liste des Garage :");
        Result res4 = bddNeo4j.run("match (g:Garage) return (g)");
        while (res4.hasNext()){
            Record rec4 = res4.next();
            System.out.println(rec4.get("g").get("nom") + " :");
            System.out.println(rec4.get("g").get("voitures"));
        }

        //Rajouter une année à toutes les personnes dans la base de donnée Neo4J
        System.out.println();
        System.out.println("Rajouter une année à toutes les personnes dans Neo4j:");
        //Result res5 = bddNeo4j.run("match (p:Personne) set p.annee = p.annee + 1 return (p)");
        Result res5 = bddNeo4j.run("match (p:Personne) return (p.annee) as annee, p");
        while (res5.hasNext()){
            Record rec5 = res5.next();
            System.out.println(rec5.get("p").get("nom"));
            String strAnnee = rec5.get("annee").toString();
            System.out.println(strAnnee);
            String strAnnee2 = strAnnee.replace("\"", "");
            Integer intAnnee = Integer.parseInt(strAnnee2);
            System.out.println(intAnnee);
            intAnnee++;
            System.out.println(intAnnee);
            String strAnnee3 = Integer.toString(intAnnee);
            System.out.println(strAnnee3);
            Result res6 = bddNeo4j.run("match (pp:Personne{nom:'"+rec5.get("p").get("nom")+"'}) set pp.annee = "+strAnnee3+" return (pp)");
            while(res6.hasNext()){
                Record rec6 = res6.next();
                System.out.println("ok");
                System.out.println(rec6.get("pp").get("prenom") + " " + rec6.get("p").get("nom") + " né en " + rec6.get("pp").get("annee"));
            }
            System.out.println("--");
            //;
            //
        }
        //Et maintenant la même chose dans la base de donnée MongoDB
        System.out.println();
        System.out.println("Rajouter une année à toutes les personnes dans MongoDB :");
        collectionPersonnes.updateMany(Filters.exists("annee"), new Document("$inc", new Document("annee", 1)));
        MongoCursor cursorPersonnes2 = collectionPersonnes.find().cursor();
        while (cursorPersonnes2.hasNext()){
            Document docPers2 = (Document) cursorPersonnes2.next();
            Personne pers2 = new Gson().fromJson(docPers2.toJson(), Personne.class);
            System.out.println(pers2.getPrenom() + " " + pers2.getNom() + " né en " + pers2.getAnnee());
        }

        collectionPersonnes.findOneAndUpdate(Filters.eq("nom", "Dupont"), new Document("$set", new Document("annee", 1111)));


        String[] t1 = {"BER","BKK","BRU","CDG","DXB","FCO","FRA","JFK","LAX","LHR","LUX","MEX","MUC","NRT","SYD","VIE","WAW","ZAG","ZRH"};
        String[][] t2 = {{"cs@heg.ch","ap@heg.ch","ft@heg.ch","ga@heg.ch","xk@heg.ch","vd@heg.ch","zh@heg.ch","sf@heg.ch","ol@heg.ch","vt@heg.ch","ac@heg.ch","qp@heg.ch","en@heg.ch","mp@heg.ch","nj@heg.ch","zc@heg.ch"}, {"fg@heg.ch","go@heg.ch","hf@heg.ch","lg@heg.ch","up@heg.ch","pp@heg.ch","qn@heg.ch","ye@heg.ch","bv@heg.ch","mz@heg.ch","gi@heg.ch","tq@heg.ch","fg@heg.ch"}, {"ui@heg.ch","zk@heg.ch","ed@heg.ch","fb@heg.ch","he@heg.ch","jw@heg.ch","rm@heg.ch","ox@heg.ch","bdd@heg.ch"}, {"as@heg.ch","ru@heg.ch","qz@heg.ch","rt@heg.ch","pk@heg.ch","fj@heg.ch","oz@heg.ch","wf@heg.ch","wm@heg.ch","cs@heg.ch","gf@heg.ch"}, {"tz@heg.ch","be@heg.ch","vi@heg.ch","vu@heg.ch","lj@heg.ch","sj@heg.ch","gx@heg.ch","sv@heg.ch","rk@heg.ch","io@heg.ch"}, {"er@heg.ch","wr@heg.ch","bj@heg.ch","jy@heg.ch","to@heg.ch","wk@heg.ch","zy@heg.ch","gg@heg.ch","yb@heg.ch","wg@heg.ch","mc@heg.ch","lj@heg.ch"}, {"jk@heg.ch","jy@heg.ch","jh@heg.ch","hr@heg.ch","hm@heg.ch","vt@heg.ch","qw@heg.ch","pc@heg.ch","bv@heg.ch","se@heg.ch","ef@heg.ch"}, {"df@heg.ch","ve@heg.ch","ht@heg.ch","gj@heg.ch","cs@heg.ch","mo@heg.ch"}, {"re@heg.ch","hj@heg.ch","kf@heg.ch","dl@heg.ch","nz@heg.ch","rs@heg.ch","to@heg.ch","im@heg.ch","ga@heg.ch","ig@heg.ch","dx@heg.ch"}, {"uz@heg.ch","sd@heg.ch","dd@heg.ch","mo@heg.ch","so@heg.ch","kp@heg.ch","pv@heg.ch","dd@heg.ch","vd@heg.ch"}, {"op@heg.ch","gg@heg.ch","fa@heg.ch","vt@heg.ch","bdd@heg.ch","je@heg.ch","tl@heg.ch","iy@heg.ch","xo@heg.ch","ut@heg.ch","tg@heg.ch","gi@heg.ch","hr@heg.ch"}, {"vb@heg.ch","jh@heg.ch","da@heg.ch","bn@heg.ch","lq@heg.ch","gs@heg.ch","sk@heg.ch","nz@heg.ch"}, {"jh@heg.ch","el@heg.ch","es@heg.ch","zv@heg.ch","os@heg.ch","oa@heg.ch","va@heg.ch","bj@heg.ch","vf@heg.ch","bk@heg.ch","dg@heg.ch"}, {"dg@heg.ch","qe@heg.ch","ra@heg.ch","yj@heg.ch","jp@heg.ch","ey@heg.ch","ep@heg.ch","mq@heg.ch","jo@heg.ch","yd@heg.ch","nt@heg.ch","bc@heg.ch","if@heg.ch","ig@heg.ch"}, {"dh@heg.ch","pf@heg.ch","xn@heg.ch","ko@heg.ch","br@heg.ch","zw@heg.ch","uv@heg.ch","qv@heg.ch","gh@heg.ch","uk@heg.ch","qz@heg.ch","tz@heg.ch","pr@heg.ch"}, {"uo@heg.ch","od@heg.ch","uh@heg.ch","ez@heg.ch","dm@heg.ch","om@heg.ch","fk@heg.ch","ku@heg.ch","rn@heg.ch"}, {"we@heg.ch","pz@heg.ch","ot@heg.ch","yv@heg.ch","er@heg.ch","lz@heg.ch","jq@heg.ch","jg@heg.ch","dk@heg.ch","hv@heg.ch","vy@heg.ch"}, {"eh@heg.ch","hg@heg.ch","pr@heg.ch","nq@heg.ch","xo@heg.ch","kj@heg.ch","gx@heg.ch","ag@heg.ch","do@heg.ch","ty@heg.ch"}, {"jl@heg.ch","nv@heg.ch","pw@heg.ch","yn@heg.ch","wm@heg.ch","ue@heg.ch","yd@heg.ch","bb@heg.ch","hd@heg.ch","jn@heg.ch","vt@heg.ch","pj@heg.ch"}};
        bddJedis.flushAll(); bddJedis.sadd("DESTINATIONS", t1); for (int ik=0; ik<t1.length; ik++) { bddJedis.sadd(t1[ik], t2[ik]); }
        for (int ij=0; ij<t1.length; ij++){
            System.out.println("Destinations depuis "+t1[ij]+" : "+bddJedis.smembers(t1[ij]));
        }

    }
}
