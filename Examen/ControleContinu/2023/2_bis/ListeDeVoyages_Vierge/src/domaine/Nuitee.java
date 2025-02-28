package domaine;

public class Nuitee {
    private String nom;
    private String cat;

    public Nuitee(String nom, String cat) {
        this.nom = nom;
        this.cat = cat;
    }

    @Override
    public String toString() { return nom + " (" + cat + ")"; }
}