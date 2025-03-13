package domaine;

import java.util.ArrayList;
import java.util.List;

public class Garage {
    private Personne proprio;
    private String nom;
    private Voiture[] voitures;

    public Garage(Personne proprio, String nom, Voiture[] voitures) {
        this.proprio = proprio;
        this.nom = nom;
        this.voitures = voitures;
    }
    public Personne getProprio() { return proprio; }
    public String getNom() { return nom; }
    public Voiture[] getVoitures() { return voitures; }
    public void setProprio(Personne proprio) { this.proprio = proprio; }
    public void setNom(String nom) { this.nom = nom; }
    public void setVoitures(Voiture[] voitures) { this.voitures = voitures; }

    public String toString() {
        String str = "";
        str += "Garage : " + nom + "\n";
        str += "    Proprietaire : " + proprio + "\n";
        str += "    Liste des voitures : \n";
        for(Voiture v : voitures){
            str += "    " + v + "\n";
        }
        return str;
    }
}
