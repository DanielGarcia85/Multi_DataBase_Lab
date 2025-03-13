package domaine;

import java.util.Date;

public class Competitions {
    private String nom;
    private Date date;
    private String lieu;
    private String ville;
    private int prix;
    private Clubs club;
    private  Participants[] participants;
    public Competitions(String nom, String lieu, String ville, int prix, Clubs club, Participants[] participants){
        this.nom = nom;
        this.date = null;
        this.lieu = lieu;
        this.ville = ville;
        this.prix = prix;
        this.club = club;
        this.participants = participants;
    }
    public Competitions(String nom, Date date, String lieu, String ville, int prix, Clubs club, Participants[] participants) {
        this.nom = nom;
        this.date = date;
        this.lieu = lieu;
        this.ville = ville;
        this.prix = prix;
        this.club = club;
        this.participants = participants;
    }

    public Competitions(String nom, Date date, String lieu, String ville, int prix, Clubs club) {
        this.nom = nom;
        this.date = date;
        this.lieu = lieu;
        this.ville = ville;
        this.prix = prix;
        this.club = club;
    }
    public String getNom() {
        return nom;
    }
    public Date getDate() {return date;}
    public String getLieux() {
        return lieu;
    }
    public String getVille() {
        return ville;
    }
    public int getPrix() {
        return prix;
    }
    public Clubs getClub() {
        return club;
    }
    public Participants[] getParticipants() {
        return participants;
    }
    public void setNom(String nom) {
        this.nom = nom;
    }
    public void setDate(Date date) {
        this.date = date;
    }
    public void setLieux(String lieux) {
        this.lieu = lieux;
    }
    public void setVille(String ville) {
        this.ville = ville;
    }
    public void setPrix(int prix) {
        this.prix = prix;
    }
    public void setClub(Clubs club) {
        this.club = club;
    }
    public void setParticipants(Participants[] participants) {
        this.participants = participants;
    }

    public String toString() {
        StringBuilder participantsStr = new StringBuilder("[");
        for (Participants participant : participants) {
            participantsStr.append(participant.toString()).append(", ");
        }
        participantsStr.delete(participantsStr.length() - 2, participantsStr.length()).append("]");

        return "Competitions : " + "\n" +
                "  nom = " + nom + "\n" +
                "  date = " + date + "\n" +
                "  lieu = " + lieu + "\n" +
                "  ville = " + ville + "\n" +
                "  prix = " + prix + "\n" +
                "  " + club + "\n" +
                "  " + participantsStr;
    }
}
