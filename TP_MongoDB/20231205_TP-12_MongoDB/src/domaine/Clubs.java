    package domaine;

    public class Clubs {
        private String nom;
        private String email;
        private String ville;
        public Clubs (String nom, String email, String ville) {
            this.nom = nom;
            this.email = email;
            this.ville = ville;
        }
        public Clubs (String nom) {
            this.nom = nom;
        }
        public String getNom() {
            return nom;
        }
        public String getemail() {
            return email;
        }
        public String getVille() {
            return ville;
        }
        public void setNom(String nom) {
            this.nom = nom;
        }
        public void setemail(String email) {
            this.email = email;
        }
        public void setVille(String ville) {
            this.ville = ville;
        }

        public String toString() {
            return "Clubs : " + "\n" +
                    "  nom = " + nom + "\n" +
                    "  email = " + email + "\n" +
                    "  ville = " + ville;
        }
    }
