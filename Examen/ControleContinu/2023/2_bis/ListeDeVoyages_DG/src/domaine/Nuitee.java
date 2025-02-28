package domaine;

public class Nuitee {
    private String nom;
    private String cat;

    public Nuitee(String nom, String cat) {
        this.nom = nom;
        this.cat = cat;
    }

    public Nuitee(String nom) {
        this.nom = nom;
    }
    public String getNom() {
        return nom;
    }
    public String getCat() {
        return cat;
    }
    public void setNom(String nom) {
        this.nom = nom;
    }
    public void setCat(String cat) {
        this.cat = cat;
    }

    @Override
    public String toString() { return nom + " (" + cat + ")"; }
}