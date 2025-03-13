package metier;

import com.google.gson.Gson;
import domain.Personne;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.args.ListPosition;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class DemoRedis {
    public DemoRedis(){

        System.out.println("-------------------------------------------------------------------------");
        System.out.println("Demonstration de l'utilisation de la bdd Redis");
        System.out.println("-------------------------------------------------------------------------");

        Jedis bdd = new Jedis();
        bdd.set("1", "1 Daniel-Garcia");
        bdd.set("2", "2;David;Garcia;1991");
        bdd.set("3", "3,Olivier,Garcia,1983,Genève");

        System.out.println("Donnees de la cef 1 : " + bdd.get("1"));
        System.out.println("Donnees de la cef 2 : " + bdd.get("2"));

        String chaineDeChar = bdd.get("3");
        System.out.println("Donnees de la cef 3 : " + chaineDeChar);

        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Insérer la chaine de caractère séparé par des virgules dans un tableau");
        String[] TablDeChamps = chaineDeChar.split(",");
        System.out.println("le 1er champ = " + TablDeChamps[0]);
        System.out.println("le 2eme champ = " + TablDeChamps[1]);
        System.out.println("le 3eme champ = " + TablDeChamps[2]);
        System.out.println("le 4eme champ = " + TablDeChamps[3]);
        System.out.println("le 5eme champ = " + TablDeChamps[4]);
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Création d'un objet de la classe Personne");
        Personne pers4 = new Personne(4, "Marcel", "Dupond", 1956);
        System.out.println(pers4.toString());
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Ce même objet de la classe Personne sous la forme Json :");
        String pers4SousFormatJson = new Gson().toJson(pers4);
        System.out.println(pers4SousFormatJson);
        System.out.println("-------------------------------------------------------------------------");

        String[] TablDeChamps2 = pers4SousFormatJson.split(",");
        System.out.println("le 1er champ = " + TablDeChamps2[0]);
        System.out.println("le 2eme champ = " + TablDeChamps2[1]);
        System.out.println("le 3eme champ = " + TablDeChamps2[2]);
        System.out.println("le 4eme champ = " + TablDeChamps2[3]);
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Cet objet de la classe Personne, au format Json, inséré dans la BDD Redis");
        bdd.set("4", pers4SousFormatJson);
        System.out.println("Donnees de la cef 4 : ");
        System.out.println(bdd.get("4"));
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Chaine au format Json inséré dans la BDD Redis");
        bdd.set("5", "{\"no\": 5,\"prenom\": \"Pierre\",\"nom\": \"Paul\",\"annee\": 1975}");
        System.out.println(bdd.get("5"));
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Chaine au format Json converti en objet de la classe Personne");
        String chaineLue = bdd.get("5");
        Personne pers5 = new Gson().fromJson(chaineLue, Personne.class);
        System.out.println(pers5.toString());
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Plusieurs valeurs en un Set et un Get");
        bdd.mset("6", "valeur 6", "7", "valeur 7", "8", "valeur 8");
        System.out.println(bdd.mget("6", "7", "8"));
        bdd.del("8");
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Afficher les types contenues dans les cles");
        System.out.println("Type de la cle 1 : "+bdd.type("1"));
        System.out.println("Type de la cle 2 : "+bdd.type("2"));
        System.out.println("Type de la cle 3 : "+bdd.type("3"));
        System.out.println("Type de la cle 4 : "+bdd.type("4"));
        System.out.println("Type de la cle 5 : "+bdd.type("5"));
        System.out.println("Type de la cle 6 : "+bdd.type("6"));
        System.out.println("Type de la cle 7 : "+bdd.type("7"));
        System.out.println("Type de la cle 8 : "+bdd.type("8"));
        System.out.println("-------------------------------------------------------------------------");

        System.out.println("Ceci est une liste stocké dans une BDD Redis");
        bdd.del("9");
        bdd.lpush("9", "champ1","champ2","champ3","champ4");
        System.out.println("Type de la cle 9 : "+bdd.type("9"));
        System.out.println(bdd.lrange("9", 0, 3));
        System.out.println(bdd.lrange("9", 0, 4));
        bdd.linsert("9", ListPosition.BEFORE, "champ4", "champ5");
        System.out.println(bdd.lrange("9", 0, 4));
        bdd.lrem("9", 1, "champ3");
        System.out.println(bdd.lrange("9", 0, 4));
        List redisListe = new ArrayList();
        redisListe = bdd.lrange("9", 0, 4);
        System.out.println(redisListe);
        System.out.println("-------------------------------------------------------------------------");

        //bdd.flushAll();
        System.out.println("Ceci est un ensemble stocké dans une BDD Redis");
        bdd.sadd("10", "1", "2", "3");
        bdd.sadd("10", "4", "5");
        System.out.println("Type de la cle 10 : "+bdd.type("10"));
        System.out.println(bdd.smembers("10"));
        System.out.println(bdd.sismember("10", "1"));
        bdd.srem("10", "1", "2");
        System.out.println(bdd.smembers("10"));
        System.out.println(bdd.sismember("10", "1"));
        HashSet redisSet = new HashSet();
        redisSet = (HashSet) bdd.smembers("10");
        System.out.println(redisSet);
        System.out.println("-------------------------------------------------------------------------");

        //bdd.expire("1", 100000000);
        //System.out.println("Time to Live pour la clé 1 : " + bdd.ttl("9"));

    }
}
