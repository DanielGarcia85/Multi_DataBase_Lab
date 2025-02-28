package metier;

import dao.Bdd;

import java.sql.ResultSet;
import java.sql.SQLException;

import static dao.Bdd.*;

import org.neo4j.driver.Result;
import org.neo4j.driver.Record;

public class AffectationProjets {
    public AffectationProjets() {
        Bdd.connect();  // vous aurez donc accès direct aux 3 variables : oracle, mongo & neo4j
        mettreAJourToutesLesBases();
    }

    private void mettreAJourToutesLesBases() {
        System.out.println("Mise-à-jour des données dans les 3 bdd...");
        // TODO: vous pouvez tout faire dans cette procédure !

        try {
            ResultSet res1 = oracle.createStatement().executeQuery("SELECT * FROM vw_exa_projets");
            while(res1.next()){
                String pro_nom = res1.getString("PROJET");
                String pro_descritpion = res1.getString("DESCRIPTION");
                String pro_priorite = res1.getString("PRIORITE");
                String cat_nom = res1.getString("CATEGORIE");
                System.out.println("Insertion dans MongoDB du projet suivant :");
                System.out.println(" - " + pro_nom + " " + pro_descritpion + " " + pro_priorite + " " + cat_nom);
                mongo.getCollection("Projet").insertOne(new org.bson.Document("nom", pro_nom).append("description", pro_descritpion).append("priorite", pro_priorite).append("categorie", cat_nom));

                Result res2 = neo4j.run("MATCH (c:Categorie) return c");
                if (!res2.hasNext()){
                    Result res3 = neo4j.run("MATCH (p:Pojet {nom: "+ pro_nom+"})");
                    while (res3.hasNext()){
                        Record rec = res3.next();
                        String pro_nom2 = rec.get("p").get("nom").asString();
                        System.out.println(pro_nom2);
                    }
                    neo4j.run("CREATE (c:Categorie{nom:'" + cat_nom + "'})-[:CATEGORIE]->(p:Projet{nom:'" + pro_nom + "'})");

                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        Result res3 = neo4j.run("match (e:Employe)-[a:AFFECTE]->(p:Projet) return e.nom as empNom, a, p.nom as proNom");
        while (res3.hasNext()){
            Record rec = res3.next();;
        }

 


    }
}