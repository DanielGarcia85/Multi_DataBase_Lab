package domaine;

public class Nuitee {
    private String nom;
    private String cat;

    public Nuitee(String nom, String cat) {
        this.nom = nom;
        this.cat = "inconnue";
    }
    public String getNom() {return nom;}
    public String getCat() {return cat;}

    @Override
    public String toString() {
        if (cat == null)
            return nom;
        else {
            return nom + " (" + cat + ")";
        }
    }
}