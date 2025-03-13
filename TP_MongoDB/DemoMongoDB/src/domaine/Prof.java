package domaine;

public class Prof {
    private String nom;
    private String prenom;
    private String filiere;

    public Prof(String nom, String prenom, String filiere) {
        this.nom = nom;
        this.prenom = prenom;
        this.filiere = filiere;
    }

    public String getNom() { return nom; }
    public String getPrenom() { return prenom; }
    public String getFiliere() { return filiere; }

    @Override
    public String toString() {
        return "Prof : " + "nom='" + nom + "'" + ", prenom='" + prenom + "'" + ", filiere='" + filiere + "'";
    }
}