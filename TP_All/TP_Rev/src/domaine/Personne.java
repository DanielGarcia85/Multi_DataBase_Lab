package domaine;

public class Personne {
    private String nom;
    private String prenom;
    private int annee;
    private Voiture voitures;
    public Personne(String nom, String prenom, int annee, Voiture voitures) {
        this.nom = nom;
        this.prenom = prenom;
        this.annee = annee;
        this.voitures = voitures;
    }
    public String getNom() { return nom; }
    public String getPrenom() { return prenom; }
    public int getAnnee() { return annee; }
    public Voiture getVoiture() { return voitures; }
    public void setNom(String nom) { this.nom = nom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public void setAnnee(int annee) { this.annee = annee; }
    public void setVoiture(Voiture voiture) { this.voitures = voiture; }

    public String toString() {
        return prenom + " " + nom + " " + annee + ", conduit : " + voitures;
    }
}
