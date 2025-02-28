package domaine;

public class Nuitee {
    private String nom;
    private String cat;

    public Nuitee(String nom, String cat) {
        this.nom = nom;
        this.cat = cat;
    }
    public Nuitee(String nom){
        this.nom = nom;
    }

    @Override
    public String toString() { return nom + " (" + cat + ")"; }
}