package domaine;

public class Statistique {
    private int annee;
    private int nb;

    public Statistique(int annee, int nb) {
        this.annee = annee;
        this.nb = nb;
    }

    @Override
    public String toString() { return annee + ":" + nb; }
}