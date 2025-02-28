package metier;

import org.neo4j.driver.*;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;
import org.neo4j.driver.Record;

import java.util.List;


public class DemoNeo4J {
    public DemoNeo4J() {

        System.out.println("-----------------------------------------------");
        System.out.println("Démonstration de l'utilisation d'une bdd Neo4J");
        System.out.println("-----------------------------------------------");

        // Connexion à la session de la bdd Neo4J
        Driver driver = GraphDatabase.driver("neo4j+s://29e3d736.databases.neo4j.io:7687", AuthTokens.basic("neo4j","19454848"));
        Session bddNeo4j = driver.session();
        // En une seule ligne de code
        //Session bddNeo4J = GraphDatabase.driver("neo4j+s://29e3d736.databases.neo4j.io:7687", AuthTokens.basic("neo4j","19454848")).session();
        // BDD local
        //Session bddNeo4J = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j","19454848")).session();
        System.out.println("-----------------------------------------------");

        // Lancement d'instruction Cypher pour Nettoyer de la bdd Neo4J
        bddNeo4j.run("match ()-[r]->() delete (r)");
        bddNeo4j.run("match (n) delete (n)");
        System.out.println("Bdd Neo4J existant supprimé");

        // Lancement d'instruction Cypher pour Creation de la bdd Neo4J
        bddNeo4j.run("create (e:Ecole{nom:'HEG',lieu:'Genève'})");
        bddNeo4j.run("create (e:Ecole{nom:'EPFL',lieu:'Lausanne'})");
        bddNeo4j.run("create (p:Prof{nom:'Moreti',prenom:'Tibault',annee:1955})");
        bddNeo4j.run("create (p:Prof{nom:'Marcel',prenom:'Jean',annee:1955})");
        bddNeo4j.run("create (e:Etudiant{nom:'Mourad',prenom:'Jack',annee:1985})");
        bddNeo4j.run("create (:Etudiant{nom:'Dupond',prenom:'Paul',annee:1985})");
        bddNeo4j.run("create (e:Etudiant{nom:'Garcia',prenom:'Daniel',annee:1985})");
        bddNeo4j.run("match (p:Prof), (e:Ecole) where e.nom='HEG' create (p)-[:ENSEGINE_DANS]->(e)");
        bddNeo4j.run("match (e:Etudiant {nom: 'Garcia'}), (c:Ecole {nom: 'EPFL'}) create (e)-[:SUIT_LES_COURS_DE]->(c)");
        bddNeo4j.run("match (e:Etudiant{nom:'Dupond'}), (c:Ecole{nom:'HEG'}) create (e)-[:SUIT_LES_COURS_DE]->(c)");
        bddNeo4j.run("match (e:Etudiant{nom:'Mourad'}), (c:Ecole{nom:'HEG'}) create (e)-[:SUIT_LES_COURS_DE]->(c)");
        bddNeo4j.run("match (e:Etudiant), (q:Etudiant) create (e)-[:EST_CAMARADE_DE]->(q)");
        bddNeo4j.run("match (e:Etudiant) -[rel]-> (e:Etudiant) delete rel");
        bddNeo4j.run("match (e:Etudiant), (c:Ecole{nom:'HEG'}) where e.nom='Garcia' create (e)-[:TRAVAIL_A]->(c)");
        bddNeo4j.run("match (e:Etudiant) -[s:SUIT_LES_COURS_DE]-> (q:Ecole{nom:'HEG'}) delete (s)");
        bddNeo4j.run("match (e:Etudiant{nom:'Mourad'}), (p:Prof{nom:'Moreti'}) create (e)-[:SUIT_LES_COURS_DE]->(p)");
        bddNeo4j.run("match (e:Etudiant{nom:'Dupond'}), (p:Prof{nom:'Marcel'}) create (e)-[:SUIT_LES_COURS_DE]->(p)");
        bddNeo4j.run("match (e:Ecole), (q:Ecole) create (e)-[:COLLABORE_AVEC]->(q)");
        bddNeo4j.run("match (e:Ecole)-[r:COLLABORE_AVEC]->(e:Ecole) delete (r)");
        bddNeo4j.run("match (e:Etudiant {nom:'Garcia'}) create (e)-[:EST_AMI_DE]->(a:Ami{nom:'Cruz', prenom:'Steve'})");
        bddNeo4j.run("match (e:Ami {nom:'Cruz'}) create (e)-[:EST_AMI_DE]->(a:Ami{nom:'Pogi', prenom:'Pilard'})");
        bddNeo4j.run("match (e:Ami {nom:'Pogi'}) create (e)-[:EST_AMI_DE]->(a:Ami{nom:'Schiffer', prenom:'Mourad'})");
        bddNeo4j.run("match (a:Ami{nom:'Cruz'}) set a.annee=1992");
        bddNeo4j.run("match (a:Ami{nom:'Pogi'}) set a.annee=1998");
        bddNeo4j.run("match (a:Ami{nom:'Schiffer'}) set a.annee=1989");
        bddNeo4j.run("match (p) set p.label = p.nom");
        System.out.println("Nouvelle BDD Neo4j créé");
        System.out.println("-----------------------------------------------");

        //Lancement d'instruction Cypher pour accéder aux données
        Result res1 = bddNeo4j.run("match (n) RETURN n.label as label, n.nom as nom, n.prenom as prenom, n.annee as annnee"); //avec un return
        //parcouri (et interpreter) les résultats
        while (res1.hasNext()){
            Record rec = res1.next();
            System.out.println("Noeud : " + rec.get("label"));
            System.out.println("Nom : " + rec.get("nom") + ", Prenom : " + rec.get("prenom") + ", Année : " + rec.get("annee"));
            System.out.println("---");
            //System.out.println(rec.get("label").get("nom")); // n, nom = nom des attributs des noeuds
        }
        System.out.println("-----------------------------------------------");
        Result res2 = bddNeo4j.run("match (x:Etudiant|Prof) RETURN x");
        while (res2.hasNext()){
            Record rec = res2.next();
            System.out.println("Nom : " + rec.get("x").get("nom"));
        }
        System.out.println("-----------------------------------------------");
        Result res3 = bddNeo4j.run("match (x) RETURN x");
        while (res3.hasNext()){
            Record rec = res3.next();
            System.out.print("Nom : " + rec.get("x").get("nom"));
            System.out.println(" | Prenom : " + rec.get("x").get("prenom"));
        }
        System.out.println("-----------------------------------------------");
        Result res4 = bddNeo4j.run("match (x) RETURN x");
        List list1 = res4.list();
        System.out.println("Taille de la liste : " + list1.size());
        for(int i=0;i<list1.size();i++){
            System.out.println(list1.get(i));
        }
        bddNeo4j.close();
    }
}
