package dao;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;

public class BddNeo4j {
    private Session session;
    public BddNeo4j() { session = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "19454848")).session(); chargerDonnees(); }
    public Result run (String instr) { return session.run(instr); }
    private void chargerDonnees() {
        session.run("MATCH (n) DETACH DELETE n");
        session.run("CREATE (c:Agence{no:1,nom:'Carouge'}), " +
                "(b:Agence{no:2,nom:'Bernex'}), " +
                "(o:Agence{no:3,nom:'Corsier'}), " +
                "(m:Agence{no:4,nom:'Meyrin'}), " +
                "(l:Agence{no:5,nom:'Lancy'}), " +
                "(c)-[:TRAJET{distance:3}]->(b), " +
                "(c)-[:TRAJET{distance:8}]->(o), " +
                "(c)-[:TRAJET{distance:6}]->(l), " +
                "(b)-[:TRAJET{distance:5}]->(c), " +
                "(b)-[:TRAJET{distance:2}]->(m), " +
                "(b)-[:TRAJET{distance:8}]->(l), " +
                "(m)-[:TRAJET{distance:3}]->(l), " +
                "(l)-[:TRAJET{distance:6}]->(c), " +
                "(l)-[:TRAJET{distance:4}]->(m)");
    }
}