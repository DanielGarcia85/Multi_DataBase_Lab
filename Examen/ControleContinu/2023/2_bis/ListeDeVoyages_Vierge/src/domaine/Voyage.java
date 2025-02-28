package domaine;

public class Voyage {
    private String email;
    private String code;
    private String destination;
    private Object nuitees;      // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Nuitees
    private Object transports;   // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Transports

    // TODO: Créez les constructeurs et/ou setters et/ou autres méthodes nécessaires

    @Override
    public String toString() {
        return "Voyage pour " + email + " à " + destination + " (" + code + "), nuitees=" + nuitees + ", transports=" + transports;
    }
}