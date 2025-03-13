package domaine;

import java.util.ArrayList;

public class Voyage {
    private String email;
    private String code;
    private String destination;
    private ArrayList<Nuitee> nuitees;      // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Nuitees
    private ArrayList<Transport> transports;   // TODO: Remplacez Object par un type vous permettant de stocker plusieurs Transports

    // TODO: Créez les constructeurs et/ou setters et/ou autres méthodes nécessaires
    public Voyage(String email, String code, String destination, ArrayList<Nuitee> nuitees, ArrayList<Transport> transports) {
        this.email = email;
        this.code = code;
        this.destination = destination;
        this.nuitees = nuitees;
        this.transports = transports;
    }

    public Voyage(String email, String code, String destination) {
        this.email = email;
        this.code = code;
        this.destination = destination;
    }

    public String getEmail() { return email; }
    public String getCode() { return code; }
    public String getDestination() { return destination; }
    public ArrayList<Nuitee> getNuitees() { return nuitees; }
    public ArrayList<Transport> getTransports() { return transports; }
    public void setEmail(String email) { this.email = email; }
    public void setCode(String code) { this.code = code; }
    public void setDestination(String destination) { this.destination = destination; }
    public void setNuitees(ArrayList<Nuitee> nuitees) { this.nuitees = nuitees; }
    public void setTransports(ArrayList<Transport> transports) { this.transports = transports; }

    @Override
    public String toString() {
        return "Voyage pour " + email + " à " + destination + " (" + code + "), nuitees=" + nuitees + ", transports=" + transports;
    }
}