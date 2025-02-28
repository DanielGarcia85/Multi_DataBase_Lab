package domaine;

public class Participants {
    private String nom;
    private String prenom;
    private String sexe;
    private String email;
    private String ville;
    private  Clubs club;
    private String clubString;

    public Participants(String nom, String prenom, String sexe, String email, String ville, Clubs club) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.email = email;
        this.ville = ville;
        this.club = club;
    }
    public Participants(String nom, String prenom, String sexe, String email, String ville, String clubString) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.email = email;
        this.ville = ville;
        this.clubString = clubString;
    }
    public Participants(String nom, String prenom, String sexe, String email, Clubs club) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.email = email;
        this.club = club;
    }
    public Participants(String nom, String prenom, String sexe, String email, String clubString) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.email = email;
        this.clubString = clubString;
    }
    public String getNom() {
        return nom;
    }
    public String getPrenom() {
        return prenom;
    }
    public String getSexe() {
        return sexe;
    }
    public String getemail() {
        return email;
    }
    public String getVille() {
        return ville;
    }
    public Clubs getClub() {
        return club;
    }
    public String getClubString() {
        return clubString;
    }
    public void setNom(String nom) {
        this.nom = nom;
    }
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    public void setSexe(String sexe) {
        this.sexe = sexe;
    }
    public void setemail(String email) {
        this.email = email;
    }
    public void setVille(String ville) {
        this.ville = ville;
    }
    public void setClub(Clubs club) {
        this.club = club;
    }
    public void setClubString(String clubString) {
        this.clubString = clubString;
    }
    public String toString() {
        return "Participants : " + "\n" +
                "  nom = " + nom + "\n" +
                "  prenom = " + prenom + "\n" +
                "  sexe = " + sexe + "\n" +
                "  email = " + email + "\n" +
                "  ville = " + ville + "\n" +
                "  club = " + club + "\n" ;
    }
}
