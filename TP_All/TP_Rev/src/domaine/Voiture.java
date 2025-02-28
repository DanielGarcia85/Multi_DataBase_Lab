package domaine;

public class Voiture {
    private String marque;
    private String model;
    private int annee;

    public Voiture(String marque, String model, int annee) {
        this.marque = marque;
        this.model = model;
        this.annee = annee;
    }
    public String getMarque() { return marque; }
    public String getModel() { return model; }
    public int getAnnee() { return annee; }
    public void setMarque(String marque) { this.marque = marque; }
    public void setModel(String model) { this.model = model; }
    public void setAnnee(int annee) { this.annee = annee; }

    public String toString() {
        return marque + " " + model + " de " + annee;
    }

}
