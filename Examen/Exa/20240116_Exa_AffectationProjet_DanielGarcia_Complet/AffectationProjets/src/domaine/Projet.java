package domaine;

public class Projet {
    private String pro_no;
    private String pro_nom;
    private String pro_fonction;

    public Projet(String pro_no, String pro_nom, String pro_fonctino) {
        this.pro_no = pro_no;
        this.pro_nom = pro_nom;
        this.pro_fonction = pro_fonction;
    }

    public String getPro_no() { return pro_no; }
    public String getPro_nom() { return pro_nom; }
    public String getPro_fonctino() { return pro_fonction; }

    public void setPro_no(String pro_no) { this.pro_no = pro_no; }
    public void setPro_nom(String pro_nom) { this.pro_nom = pro_nom; }
    public void setPro_fonction(String pro_fonction) { this.pro_fonction = pro_fonction; }

}
