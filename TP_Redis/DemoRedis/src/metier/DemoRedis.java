package metier;

import com.google.gson.Gson;
import domaine.Personne;
import redis.clients.jedis.Jedis;

public class DemoRedis {
    public DemoRedis() {
        System.out.println("Démonstration de l'utilisation de Redis");
        Jedis bdd = new Jedis();

        // 1) on stocke juste une valeur associée à une clé :
        bdd.set("11", "Durand");

        // 2) on récupère cette valeur, et on l'affiche :
        String texte = bdd.get("11");
        System.out.println(texte);

        // 3) pour stocker plusieurs valeurs, il faut tout mettre dans un String
        bdd.set("33", "Stettler;Christian;1999;5555;Informatique;HEG");

        // 4) lorsqu'on récupère ce String, c'est le programme qui doit le décomposer
        String valeur = bdd.get("33");                // lit la clé 33 dans Redis, retourne la valeur
        String[] champs = valeur.split(";");    // décompose le texte (format csv par exemple)
        System.out.println("Le 1er champ=" + champs[0] + ", le 2ème=" + champs[1] + ", le 3ème=" + champs[2]);

        Personne pers = new Personne(44, "Dufour", "Paul", 1987, "HEG");

        // 5) possibilité de convertir une instance d'une classe au format Json (en utilisant Gson)
        String persAuFormatJson = new Gson().toJson(pers);
        bdd.set("55", persAuFormatJson);

        // 6) relire cette valeur dans la bdd, décomposer en utilisant fromJson pour retrouver une instance de Personne
    }
}
