package domain;

public class Employe {
    private String nom;
    private String prenom;
    private int salaire;
    private String dept;

    public Employe(String nom, String prenom, int salaire, String dept) {
        this.nom = nom;
        this.prenom = prenom;
        this.salaire = salaire;
        this.dept = dept;
    }

    public void print(){
        System.out.println("Nom : " + this.nom);
        System.out.println("Préom : " + this.prenom);
        System.out.println("Salaire : " + this.salaire);
        System.out.println("Dept : " + this.dept);
    }
}
