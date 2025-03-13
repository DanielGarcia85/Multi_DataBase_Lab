package domaine;

import java.util.ArrayList;

public class Voyage {
    private String email;
    private String code;
    private String destination;
    private ArrayList<Transport> nuitees;      // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Nuitees
    private ArrayList<Transport> transports;   // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Transports

    // TODO: Créez les constructeurs et/ou setters et/ou autres méthodes nécessaires

    @Override
    public String toString() {
        return "Voyage pour " + email + " à " + destination + " (" + code + "), nuitees=" + nuitees + ", transports=" + transports;
    }
}