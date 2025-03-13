package domaine;

public class Transport {
    private String type;
    private String compagnie;

    public Transport(String type, String compagnie) {
        this.type = type;
        this.compagnie = compagnie;
    }

    @Override
    public String toString() { return "en " + type + " (" + compagnie + ")"; }
}