package metier;

import domaine.Garage;
import domaine.Personne;
import domaine.Voiture;

public class BddObject {

    // Creation des instances de la classe Voiture
    Voiture v1 = new Voiture("Peugeot", "206", 2000);
    Voiture v2 = new Voiture("WW", "Golf", 2005);
    Voiture v3 = new Voiture("Mercedes", "A5", 1995);
    Voiture v4 = new Voiture("Renault", "Clio", 2015);
    Voiture v5 = new Voiture("Fiat", "Punto", 2020);
    Voiture v6 = new Voiture("Porsh", "Carrera", 1985);
    Voiture v7 = new Voiture("Ford", "Focus", 2001);

    // Creation des instances de la classe Personne
    Personne p1 = new Personne("Dupont", "Jean", 1985, v1);
    Personne p2 = new Personne("Durand", "Pierre", 1990, v2);
    Personne p3 = new Personne("Martin", "Paul", 1995, v3);
    Personne p4 = new Personne("Dubois", "Jacques", 2000, v4);
    Personne p5 = new Personne("Lefebvre", "Jeanne", 2005, v5);
    Personne p6 = new Personne("Leroy", "Marie", 2010, v6);
    Personne p7 = new Personne("Moreau", "Julie", 2015, v7);

    // Creation des instances de la classe Garage
    Voiture[] voitures1 = {v1, v2, v3};
    Voiture[] voitures2 = {v4, v5, v6};
    Voiture[] voitures3 = {v7};
    Voiture[] voitures4 = {};
    Voiture[] voitures5 = {v1, v2, v3, v4, v5, v6, v7};
    Garage g1 = new Garage(p1, "Garage_1", voitures1);
    Garage g2 = new Garage(p2, "Garage_2", voitures2);
    Garage g3 = new Garage(p3, "Garage_3", voitures3);
    Garage g4 = new Garage(p3, "Garage_4", voitures4);
    Garage g5 = new Garage(p4, "Garage_5", voitures5);

    // Accès aux instances
    public Voiture getV1() { return v1; }
    public Voiture getV2() { return v2; }
    public Voiture getV3() { return v3; }
    public Voiture getV4() { return v4; }
    public Voiture getV5() { return v5; }
    public Voiture getV6() { return v6; }
    public Voiture getV7() { return v7; }
    public Personne getP1() { return p1; }
    public Personne getP2() { return p2; }
    public Personne getP3() { return p3; }
    public Personne getP4() { return p4; }
    public Personne getP5() { return p5; }
    public Personne getP6() { return p6; }
    public Personne getP7() { return p7; }
    public Garage getG1() { return g1; }
    public Garage getG2() { return g2; }
    public Garage getG3() { return g3; }
    public Garage getG4() { return g4; }
    public Garage getG5() { return g5; }

}
