package domaine;

import java.util.ArrayList;
import java.util.List;

public class Producteur {
    private String nom;
    private String lieu;
    private List<Statistique> stat;
    private List<String> magasins;

    public Producteur(String nom, String lieu, List<Statistique> stat, List<String> magasins) {
        this.nom = nom;
        this.lieu = lieu;
        this.stat = stat;
        this.magasins = magasins;
    }

    public String getNom() { return nom; }
    public String getLieu() { return lieu; }
    public void addStat(Statistique s) { if (stat==null) stat=new ArrayList<>(); stat.add(s); }
    public void addMagasin(String magasin) { if (magasins==null) magasins=new ArrayList<>(); magasins.add(magasin); }

    @Override
    public String toString() {
        return " - Producteur " + nom + " (" + lieu + "), Stat: " + stat + ", magasins: " + magasins;
    }
}