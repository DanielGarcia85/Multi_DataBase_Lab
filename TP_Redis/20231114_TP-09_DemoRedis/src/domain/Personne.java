package domain;

public class Personne {
    private int no;
    private String prenom;
    private String nom;
    private int annee;

    public Personne(int no, String prenom, String nom, int annee) {
        this.no = no;
        this.prenom = prenom;
        this.nom = nom;
        this.annee = annee;
    }

    @Override
    public String toString() {
        return "  Personne N°"+no+"\n"+"  Prénom : "+prenom+"\n"+"  Nom : "+nom+"\n"+"  Né en "+annee;
    }

}
