package dao;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;
import redis.clients.jedis.Jedis;

import java.util.logging.Level;
import java.util.logging.Logger;

public class Bdd {
    // TODO: indiquez vos url de connexion ainsi que le mot de passe de votre base Neo4j
    private static final String URL_MONGO = "mongodb://localhost";
    private static final String URL_NEO4J = "bolt://localhost:7687";
    private static final String PWD_NEO4J = "19454848";

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!           NE MODIFIEZ PAS LE CODE DE CETTE CLASSE           !!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    public static Jedis jedis = null;
    public static MongoDatabase mongo = null;
    public static Session neo4j = null;

    public static void connect() {
        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);
        jedis = new Jedis();
        mongo = MongoClients.create(URL_MONGO).getDatabase("Voya");
        neo4j = GraphDatabase.driver(URL_NEO4J, AuthTokens.basic("neo4j", PWD_NEO4J)).session();

        String[] t1 = {"BER","BKK","BRU","CDG","DXB","FCO","FRA","JFK","LAX","LHR","LUX","MEX","MUC","NRT","SYD","VIE","WAW","ZAG","ZRH"};
        String[][] t2 = {{"cs@heg.ch","ap@heg.ch","ft@heg.ch","ga@heg.ch","xk@heg.ch","vd@heg.ch","zh@heg.ch","sf@heg.ch","ol@heg.ch","vt@heg.ch","ac@heg.ch","qp@heg.ch","en@heg.ch","mp@heg.ch","nj@heg.ch","zc@heg.ch"}, {"fg@heg.ch","go@heg.ch","hf@heg.ch","lg@heg.ch","up@heg.ch","pp@heg.ch","qn@heg.ch","ye@heg.ch","bv@heg.ch","mz@heg.ch","gi@heg.ch","tq@heg.ch","fg@heg.ch"}, {"ui@heg.ch","zk@heg.ch","ed@heg.ch","fb@heg.ch","he@heg.ch","jw@heg.ch","rm@heg.ch","ox@heg.ch","bdd@heg.ch"}, {"as@heg.ch","ru@heg.ch","qz@heg.ch","rt@heg.ch","pk@heg.ch","fj@heg.ch","oz@heg.ch","wf@heg.ch","wm@heg.ch","cs@heg.ch","gf@heg.ch"}, {"tz@heg.ch","be@heg.ch","vi@heg.ch","vu@heg.ch","lj@heg.ch","sj@heg.ch","gx@heg.ch","sv@heg.ch","rk@heg.ch","io@heg.ch"}, {"er@heg.ch","wr@heg.ch","bj@heg.ch","jy@heg.ch","to@heg.ch","wk@heg.ch","zy@heg.ch","gg@heg.ch","yb@heg.ch","wg@heg.ch","mc@heg.ch","lj@heg.ch"}, {"jk@heg.ch","jy@heg.ch","jh@heg.ch","hr@heg.ch","hm@heg.ch","vt@heg.ch","qw@heg.ch","pc@heg.ch","bv@heg.ch","se@heg.ch","ef@heg.ch"}, {"df@heg.ch","ve@heg.ch","ht@heg.ch","gj@heg.ch","cs@heg.ch","mo@heg.ch"}, {"re@heg.ch","hj@heg.ch","kf@heg.ch","dl@heg.ch","nz@heg.ch","rs@heg.ch","to@heg.ch","im@heg.ch","ga@heg.ch","ig@heg.ch","dx@heg.ch"}, {"uz@heg.ch","sd@heg.ch","dd@heg.ch","mo@heg.ch","so@heg.ch","kp@heg.ch","pv@heg.ch","dd@heg.ch","vd@heg.ch"}, {"op@heg.ch","gg@heg.ch","fa@heg.ch","vt@heg.ch","bdd@heg.ch","je@heg.ch","tl@heg.ch","iy@heg.ch","xo@heg.ch","ut@heg.ch","tg@heg.ch","gi@heg.ch","hr@heg.ch"}, {"vb@heg.ch","jh@heg.ch","da@heg.ch","bn@heg.ch","lq@heg.ch","gs@heg.ch","sk@heg.ch","nz@heg.ch"}, {"jh@heg.ch","el@heg.ch","es@heg.ch","zv@heg.ch","os@heg.ch","oa@heg.ch","va@heg.ch","bj@heg.ch","vf@heg.ch","bk@heg.ch","dg@heg.ch"}, {"dg@heg.ch","qe@heg.ch","ra@heg.ch","yj@heg.ch","jp@heg.ch","ey@heg.ch","ep@heg.ch","mq@heg.ch","jo@heg.ch","yd@heg.ch","nt@heg.ch","bc@heg.ch","if@heg.ch","ig@heg.ch"}, {"dh@heg.ch","pf@heg.ch","xn@heg.ch","ko@heg.ch","br@heg.ch","zw@heg.ch","uv@heg.ch","qv@heg.ch","gh@heg.ch","uk@heg.ch","qz@heg.ch","tz@heg.ch","pr@heg.ch"}, {"uo@heg.ch","od@heg.ch","uh@heg.ch","ez@heg.ch","dm@heg.ch","om@heg.ch","fk@heg.ch","ku@heg.ch","rn@heg.ch"}, {"we@heg.ch","pz@heg.ch","ot@heg.ch","yv@heg.ch","er@heg.ch","lz@heg.ch","jq@heg.ch","jg@heg.ch","dk@heg.ch","hv@heg.ch","vy@heg.ch"}, {"eh@heg.ch","hg@heg.ch","pr@heg.ch","nq@heg.ch","xo@heg.ch","kj@heg.ch","gx@heg.ch","ag@heg.ch","do@heg.ch","ty@heg.ch"}, {"jl@heg.ch","nv@heg.ch","pw@heg.ch","yn@heg.ch","wm@heg.ch","ue@heg.ch","yd@heg.ch","bb@heg.ch","hd@heg.ch","jn@heg.ch","vt@heg.ch","pj@heg.ch"}};
        String[] t3 = {"{'code':'BER','destination':'Berlin','nuitees':[{'nom':'Ibis','cat':'5*'},{'nom':'Majestic','cat':'5*'},{'nom':'Excalibur','cat':'5*'},{'nom':'Atlantis','cat':'5*'}]}","{'code':'BKK','destination':'Bangkok','nuitees':[{'nom':'Carlton','cat':'5*'},{'nom':'Sheraton','cat':'5*'}]}","{'code':'BRU','destination':'Brussels','nuitees':[{'nom':'Novotel','cat':'4*'},{'nom':'Sheraton','cat':'5*'}]}","{'code':'CDG','destination':'Paris','nuitees':[{'nom':'Imperial','cat':'5*'},{'nom':'Mercure','cat':'5*'}]}","{'code':'DXB','destination':'Dubai','nuitees':[{'nom':'Excalibur','cat':'5*'},{'nom':'Palazio','cat':'5*'}]}","{'code':'FCO','destination':'Rome','nuitees':[{'nom':'Hilton','cat':'5*'},{'nom':'Flamingo','cat':'4*'}]}","{'code':'FRA','destination':'Francfort','nuitees':[{'nom':'Marriott','cat':'3*'},{'nom':'Imperial','cat':'4*'}]}","{'code':'JFK','destination':'New York','nuitees':[{'nom':'Bellagio','cat':'5*'},{'nom':'InterContinental','cat':'5*'},{'nom':'Moon Palace','cat':'5*'},{'nom':'Palazio','cat':'5*'}]}","{'code':'LAX','destination':'Los Angeles','nuitees':[{'nom':'Mandalay Bay','cat':'5*'},{'nom':'Royal','cat':'5*'}]}","{'code':'LHR','destination':'London','nuitees':[{'nom':'Sofitel','cat':'5*'},{'nom':'Atlantis','cat':'4*'}]}","{'code':'LUX','destination':'Luxembourg','nuitees':[{'nom':'Ambassador','cat':'5*'},{'nom':'Mercure','cat':'3*'}]}","{'code':'MEX','destination':'Mexico','nuitees':[{'nom':'Ibis','cat':'5*'},{'nom':'Flamingo','cat':'5*'}]}","{'code':'MUC','destination':'Munich','nuitees':[{'nom':'Atlantis','cat':'5*'},{'nom':'Moon Palace','cat':'5*'}]}","{'code':'NRT','destination':'Tokyo','nuitees':[{'nom':'Paradise','cat':'5*'},{'nom':'Flamingo','cat':'3*'}]}","{'code':'SYD','destination':'Sydney','nuitees':[{'nom':'InterContinental','cat':'4*'},{'nom':'Moon Palace','cat':'4*'},{'nom':'Majestic','cat':'4*'},{'nom':'Royal','cat':'5*'}]}","{'code':'VIE','destination':'Vienne','nuitees':[{'nom':'Caesars Palace','cat':'5*'},{'nom':'Majestic','cat':'4*'}]}","{'code':'WAW','destination':'Varsovie','nuitees':[{'nom':'Imperial','cat':'4*'},{'nom':'Ambassador','cat':'4*'}]}","{'code':'ZAG','destination':'Zagreb','nuitees':[{'nom':'Majestic','cat':'4*'},{'nom':'Hilton','cat':'5*'}]}","{'code':'ZRH','destination':'Zurich','nuitees':[{'nom':'Bellagio','cat':'4*'},{'nom':'Carlton','cat':'5*'}]}"};
        String[] t4 = {"BER;Berlin;AVION;KLM","BKK;Bangkok;AVION;Etihad","BRU;Brussels;CAR;Flixbus;TRAIN;SNCB","CDG;Paris;TRAIN;SNCF;CAR;Flixbus;AVION;AirFrance","DXB;Dubai;AVION;Emirates","FCO;Rome;AVION;easyJet;TRAIN;Trenitalia","FRA;Francfort;AVION;KLM","JFK;New York;AVION;Swiss;AVION;United;AVION;Lufthansa","LAX;Los Angeles;AVION;Lufthansa","LHR;London;AVION;easyJet","LUX;Luxembourg;AVION;KLM;TRAIN;SNCF;AVION;Lufthansa","MEX;Mexico;AVION;Iberia","MUC;Munich;TRAIN;SBB","NRT;Tokyo;AVION;Etihad","SYD;Sydney;AVION;AirFrance","VIE;Vienne;AVION;Lufthansa;TRAIN;OBB","WAW;Varsovie;AVION;Lufthansa","ZAG;Zagreb;AVION;easyJet","ZRH;Zurich;TRAIN;CFF;CAR;Helvecie"};
        String[] t5 = {"CDG","BKK","AVION","AirFrance","CDG","SYD","AVION","AirFrance","BRU","LUX","CAR","Flixbus","FRA","JFK","AVION","Lufthansa","CDG","BRU","AVION","AirFrance","CDG","BRU","CAR","Helvecie","LHR","SYD","AVION","Etihad","CDG","LUX","AVION","AirFrance","ZRH","NRT","AVION","Swiss","LUX","BRU","TRAIN","SNCF","FRA","MEX","AVION","Iberia","LUX","ZRH","TRAIN","CFF","FCO","DXB","AVION","Etihad"};

        jedis.flushAll(); jedis.sadd("DESTINATIONS", t1); for (int i=0; i<t1.length; i++) { jedis.sadd(t1[i], t2[i]); }
        MongoCollection coll = mongo.getCollection("Voyage"); coll.drop(); for (int i=0; i<t3.length; i++) { coll.insertOne(Document.parse(t3[i])); }
        neo4j.run("MATCH (n) DETACH DELETE n"); neo4j.run("CREATE (:Depart{code:'GVA',ville:'Geneve'})");
        for (int i=0; i<t4.length; i++) { String[] champs = t4[i].split(";"); neo4j.run("CREATE (:Destination{code:'"+champs[0]+"',ville:'"+champs[1]+"'})"); for (int j=2; j<champs.length; j+=2) { neo4j.run("MATCH (d:Depart),(a:Destination{code:'"+champs[0]+"'}) CREATE (d)-[:"+champs[j]+"{compagnie:'"+champs[j+1]+"'}]->(a)"); } }
        for (int i=0; i<t5.length; i+=4) { neo4j.run("MATCH (d{code:'"+t5[i]+"'}),(a{code:'"+t5[i+1]+"'}) CREATE (d)-[:"+t5[i+2]+"{compagnie:'"+t5[i+3]+"'}]->(a)"); }
    }
}