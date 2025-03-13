package metier;

import dao.Bdd;
import domaine.Voyage;

import java.util.ArrayList;
import java.util.List;

public class ListeDeVoyages {

    public ListeDeVoyages() {
        Bdd.connect(); // Connexion aux 3 bdd (jedis, mongo, neo4j)
        creerLesVoyagesPour("bdd@heg.ch");
        autresTransportsPossiblesPour("LUX");
        modifierLesTransports("AVION", "KLM", "AVION", "AirFrance");
        modifierLesTransports("CAR", "Helvecie", "TRAIN", "CFF");
        ajouterVoyage("AMS", "Amsterdam", "Royal", "Imperial", "5*");
        sInscrireAuxVoyagesSelonNomHotel("Royal");
    }

    private void creerLesVoyagesPour(String email) {
        List<Voyage> voyages = new ArrayList<>();
        // TODO: Créez des instances de la classe Voyage pour chaque destination à laquelle <email> s'est inscrit (dans Redis),
        //       supprimez ces inscriptions de Redis (ôtez son email des listes)
        //       puis affichez l'ArrayList voyages (aucun autre affichage dans cette procédure, uniquement l'ArrayList !)

        System.out.println("Liste des voyages où " + email + " est inscrit :");
        for (Voyage v : voyages) System.out.println(v);  // l'affichage de tous les voyages pour <email> doit se faire ici
    }

    private void autresTransportsPossiblesPour(String code) {
        // TODO: Affichez les autres transports à destination de <code> qui ne partent pas du :Départ standard
        System.out.println("Autres transports à destination de " + code + " qui ne partent pas du Départ standard :");
    }

    private void modifierLesTransports(String ancienType, String ancienneCompagnie, String nouveauType, String nouvelleCompagnie) {
        // TODO: Tous les transports de <ancienType> qui étaient effectués par l'<ancienneCompagnie> sont remplacés par les nouvelles données :
    }

    private void ajouterVoyage(String code, String destination, String nomHotel1, String nomHotel2, String cat) {
        // TODO: Ajoutez un nouveau voyage à destination de <code> dans lequel se trouve les 2 hôtels spécifiés
    }

    private void sInscrireAuxVoyagesSelonNomHotel(String nomHotel) {
        // TODO: Inscrivez-vous (rajoutez vos initiales@heg.ch) dans la bdd Redis pour toutes les destinations où se trouve un hôtel <nomHotel>
        System.out.println("Hôtel " + nomHotel + " existe à " + "??????????");
    }
}