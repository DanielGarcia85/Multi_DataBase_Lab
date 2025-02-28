package domaine;

public class Personne {
    private int no;
    private String nom;
    private String prenom;
    private int annee;
    private String ecole;

    public Personne(int no, String nom, String prenom, int annee, String ecole) {
        this.no = no;
        this.nom = nom;
        this.prenom = prenom;
        this.annee = annee;
        this.ecole = ecole;
    }

    @Override
    public String toString() {
        return "Personne{" +
                "no=" + no +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", annee=" + annee +
                ", ecole='" + ecole + '\'' +
                '}';
    }
}