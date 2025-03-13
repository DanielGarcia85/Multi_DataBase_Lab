package metier;

import com.google.gson.Gson;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import domaine.Competitions;
import domaine.Participants;
import domaine.Clubs;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.time.LocalDate;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MongoDB_TP {
    public MongoDB_TP() {

        Logger.getLogger("org.mongodb.driver").setLevel(Level.SEVERE);

        // Connection Base de donnée
        MongoDatabase bddMongo = MongoClients.create("mongodb://localhost").getDatabase("mongodb_tp");
        MongoCollection collectionClubs = bddMongo.getCollection("clubs");
        MongoCollection collectionCompetitions = bddMongo.getCollection("competitions");

        // 1.
        // Ajouter un club et une compétition
        System.out.println("Exercice 1");
        System.out.println("----------");
        // Supprime le club si il existe déjà
        collectionClubs.deleteOne(Filters.eq("nom", "Ping-Pong HEG"));
        // Insère le club dans la bdd MongoDB
        collectionClubs.insertOne(
                new Document("nom","Ping-Pong HEG")
                .append("email","pingpong@heg.ch")
                .append("ville","Carouge"));
        // Récupère le club Ping-Pong HEG
        Document docClubPingPongHEG = (Document) collectionClubs.find(Filters.eq("nom", "Ping-Pong HEG")).first();
        // Confirmation de l'insertion
        System.out.println("Le club " + docClubPingPongHEG.get("nom") + " basé à " + docClubPingPongHEG.get("ville") + " a été correctement ajouté.");
        Clubs ClubPingPongHEG = new Gson().fromJson(docClubPingPongHEG.toJson(), Clubs.class);
        System.out.println(docClubPingPongHEG.toString());
        System.out.println(ClubPingPongHEG.toString());

        // Supprime la compétition si elle existe déjà
        collectionCompetitions.deleteOne(Filters.eq("nom", "Le grand tour de table"));
        //LocalDate dateCompet = LocalDate.of(2023,1,15); // Cela n'a pas l'air de fonctionner
        // Insère la compétition dans la bdd MongoDB (avec le club précédement créé)
        collectionCompetitions.insertOne(new Document("nom","Le grand tour de table")
                .append("date", "15.01.2023")
                .append("lieu","Batelle")
                .append("ville","Carouge")
                .append("prix",5)
                .append("club", docClubPingPongHEG)
                .append("participants", Arrays.asList(
                        new Document("nom","Nepa")
                                .append("prenom","Jean")
                                .append("sexe","M")
                                .append("email","jn@hesge.ch")
                                .append("ville", "Genève")
                                .append("club", docClubPingPongHEG),
                        new Document("nom","Garcia")
                                .append("prenom","Daniel")
                                .append("sexe","M")
                                .append("email","daniel@example.com")
                                .append("ville", "Barcelone")
                                .append("club", docClubPingPongHEG)
                )));
        // Récupère la compétition Le grand tour de table
        Document docCompetLGTDT = (Document) collectionCompetitions.find(Filters.eq("nom", "Le grand tour de table")).first();
        // Confirmation de l'insertion
        System.out.println();
        System.out.println("La compétition '" + docCompetLGTDT.get("nom") + "' organisé par le club " + docClubPingPongHEG.get("nom") + " a été correctement ajoutée.");
        System.out.println(docCompetLGTDT.toJson());
        //Competitions CompetLGTDT = new Gson().fromJson(docCompetLGTDT.toJson(), Competitions.class);
        //System.out.println(CompetLGTDT.toString());
        System.out.println();



        // 2.
        // Afficher les compétitions auxquelles ont participé Dorsa et Metre
        System.out.println("Exercice 2");
        System.out.println("----------");
        MongoCursor<Document> cursCompet2 = collectionCompetitions.find().cursor();
        while(cursCompet2.hasNext()){
            Document compet2 = cursCompet2.next();
            String nomCompet2 = (String) compet2.get("nom");
            Date dateCompet2 = null;
            try{dateCompet2 = compet2.getDate("date");}
            catch (Exception e){
                String dateCompetNonValide2 = (String) compet2.get("date");
                System.out.println("Attention : La compétition '" + nomCompet2 + "' du '" + dateCompetNonValide2+ "' n'a pas de date au format valide");
                continue;
            }
            List<Document> participantsList2 = compet2.getList("participants", Document.class);
            if(participantsList2 != null) {
                for (Document participant2 : participantsList2) {
                    String nomParticipant2 = participant2.getString("nom");
                    String prenomParticipant2 = participant2.getString("prenom");
                    if (nomParticipant2.equals("Dorsa")) {
                        System.out.println("La participante '" + nomParticipant2 + " " + prenomParticipant2 + " a participé à la compétition '" + nomCompet2 + " le " + dateCompet2);
                    }
                    if (nomParticipant2.equals("Metre")){
                        System.out.println("Le participant '" + nomParticipant2 + " " + prenomParticipant2 + " a participé à la compétition '" + nomCompet2 + " le " + dateCompet2);
                    }
                }
            }
        }
        System.out.println();


        // 2.
        // Afficher les compétitions auxquelles ont participé Dorsa et Metre
        System.out.println("Exercice 2");
        System.out.println("----------");
        List<String> listPart = List.of("Dorsa", "Metre"); // => Peut être utilisé pour la méthode Filters.in
        MongoCursor<Document> cursCompet22 = collectionCompetitions.find(Filters.in("participants.nom", "Dorsa", "Metre")).cursor();
        while (cursCompet22.hasNext()){
            Document compet22 = cursCompet22.next();
            List<Document> participantsList22 = compet22.getList("participants", Document.class); // Ou List<Document> participantsList22 = (List) comp.get("participants");
            for(Document participants22 : participantsList22){
                if(participants22.get("nom").equals("Dorsa") || participants22.get("nom").equals("Metre")) {
                    System.out.println((participants22.get("nom").equals("Metre") ? "Le participant " : "La participante ") + participants22.get("nom") + " " + participants22.get("prenom") + "' a participé à la compétition '" + compet22.get("nom") + "' le " + compet22.get("date"));
                }
            }
        }
        System.out.println();

        // 3.
        // Supprimer les compétitions passés qui n'ont pas eu de participants
        System.out.println("Exercice 3");
        System.out.println("----------");
        MongoCursor<Document> cursCompet3 = collectionCompetitions.find().cursor();
        int i3 = 0;
        while (cursCompet3.hasNext()){
            Document compet3 = cursCompet3.next();
            List<Document> participantsList3 = compet3.getList("participants", Document.class);
            if (participantsList3 == null && compet3.getDate("date").before(new Date())){
                collectionCompetitions.deleteOne(Filters.eq("nom", compet3.get("nom")));
                System.out.println("La competition '" + compet3.get("nom") + "' du " + compet3.get("date") + " a été supprimé car il n'y a eu aucun participant");
                i3++;
            }
        }
        if (i3==0){System.out.println("Aucune compétition n'a été supprimée");}
        System.out.println();

        //ou
        Bson filtre1 = Filters.exists("participants", false);
        Bson filtre2 = Filters.lt("date", new Date());
        MongoCursor<Document> cursCompet = collectionCompetitions.find(Filters.and(filtre1, filtre2)).cursor();
        collectionCompetitions.deleteMany(Filters.and(filtre1, filtre2));
        while (cursCompet.hasNext()){
            Document compet =cursCompet.next();
            System.out.println("La compétition " + compet.get("nom") + " a été supprimée");
        }
        System.out.println();

        // 4.
        // Ajouter des participants à une compétition
        System.out.println("Exercice 4");
        System.out.println("----------");
        // Definir les constantes
        String NOM_CLUB1 = "HEG-Running";
        String NOM_CLUB2 = "Basketball HEG";
        String NOM_COMPETITION = "Course diplômésHEG";
        // Créer les instance de Clubs depuis les Documents correspondant même si ils n'existent pas dans la collection Clubs
        Document docClub1 = (Document) collectionClubs.find(Filters.eq("nom", NOM_CLUB1)).first();
        Document docClub2 = (Document) collectionClubs.find(Filters.eq("nom", NOM_CLUB2)).first();
        Clubs club1 = null;
        Clubs club2 = null;
        if (docClub1 == null){
            club1 = new Clubs(NOM_CLUB1);
        }else{ String jsonClub1 = docClub1.toJson();
            club1 = new Gson().fromJson(jsonClub1 , Clubs.class);
        }
        if (docClub2 == null){
            club2 = new Clubs(NOM_CLUB2);
        }else{
            String jsonClub2 = docClub2.toJson();
            club2 = new Gson().fromJson(jsonClub2 , Clubs.class);
        }
        // Ou
        //Document club1 = collectionClubs.find(Filters.eq("nom", "HEG-Running")).first();
        //Document club2 = new Document("nom", "Basketball-HEG");
        // Créer les documents des participants avec leur clubs respectifs et à partir d'instance de Participants
        Participants participant1 = new Participants("Onyme", "Anne", "F", "oa@hes.ch", "Genève", club1);
        Participants participant2 = new Participants("Neymar", "Jean", "M", "jn@hes.ch", club2);
        String jsonParticipant1 = new Gson().toJson(participant1);
        String jsonParticipant2 = new Gson().toJson(participant2);
        Document docParticipant1 = Document.parse(jsonParticipant1);
        Document docParticipant2 = Document.parse(jsonParticipant2);
        // Ajouter les participants à la compétition
        collectionCompetitions.updateOne(Filters.eq("nom", NOM_COMPETITION),new Document("$push", new Document("participants", docParticipant1)));
        collectionCompetitions.updateOne(Filters.eq("nom", NOM_COMPETITION),new Document("$push", new Document("participants", docParticipant2)));
        //ou
        collectionCompetitions.updateOne(Filters.eq("nom", NOM_COMPETITION), Updates.push("participants", docParticipant1));
        collectionCompetitions.updateOne(Filters.eq("nom", NOM_COMPETITION), Updates.push("participants", docParticipant2));
        // Confirmation de l'ajout
        System.out.println("Le participant '" + participant1.getNom() + " " + participant1.getPrenom() + "' a été ajouté à la compétition '" + NOM_COMPETITION + "'");
        System.out.println("Le participant '" + participant2.getNom() + " " + participant2.getPrenom() + "' a été ajouté à la compétition '" + NOM_COMPETITION + "'");
        System.out.println();

        // 5.
        // Afficher une liste distincte des participants inscrits à une compétition
        System.out.println("Exercice 5");
        System.out.println("----------");
        // Récupère la liste des participants distincts des compétitions
        ArrayList<Document> listParticipant5 = (ArrayList<Document>) collectionCompetitions.distinct("participants", Document.class).into(new ArrayList());
        // Parcours la liste des participants et affiche leur nom et prénom
        for(int i=0; i<listParticipant5.size(); i++) {
            System.out.println(listParticipant5.get(i).toString());

            Document doc = (Document) listParticipant5.get(i);
            System.out.println(doc.get("nom"));

            System.out.println(listParticipant5.get(i).get("nom"));
            String str = (String) listParticipant5.get(i).get("nom");
            System.out.println(str);
            Document doc2 = (Document) listParticipant5.get(i).get("club");
            System.out.println(doc2);
        }
        for(Document doc : listParticipant5){
            System.out.println(doc.get("nom") + " " + doc.get("prenom") + " " + doc.get("sexe"));
        }
        System.out.println();

        // 6.
        // Affichez la list des clubs des compétitions et leurs participants
        System.out.println("Exercice 6");
        System.out.println("----------");
        MongoCursor<Document> cursCompetition6 = collectionCompetitions.find().cursor();
        while (cursCompetition6.hasNext()){
            Document competition6 = cursCompetition6.next();
            Document club6 = (Document) competition6.get("club");
            System.out.println("Club : " + club6.get("nom"));
            List<Document> listParticipant6 = competition6.getList("participants", Document.class);
            System.out.println("Participants : ");
            for(int i=0; i<listParticipant6.size();i++){
                System.out.println(" " + listParticipant6.get(i).get("nom"));
            }
            System.out.println("----------");
        }
        System.out.println();

        // 6.bis
        // Affichez la list des clubs des compétitions et leurs participants
        System.out.println("Exercice 6 bis");
        System.out.println("--------------");
        MongoCursor<Document> cursClubs = collectionClubs.find().cursor();
        List<Document> fullList = new ArrayList<>();
        while(cursClubs.hasNext()){
            Document club = cursClubs.next();
            System.out.println("Voici les membres du club : " + club.get("nom"));

            List<Document> listCompet = (List<Document>) collectionCompetitions.find(Filters.eq("participants.club", club)).into(new ArrayList());

            Set<String> displayedParticipants = new HashSet<>();

            for (Document competition : listCompet) {
                List<Document> participants = (List<Document>) competition.getList("participants", Document.class);
                for (Document participant : participants) {
                    if (participant.containsKey("club") && participant.get("club") != null) {
                        Document participantClub = (Document) participant.get("club");
                        if (participantClub.get("nom").equals(club.get("nom"))) {
                            String participantFullName = participant.get("prenom") + " " + participant.get("nom");
                            if (!displayedParticipants.contains(participantFullName)) {
                                System.out.println(" - " + participantFullName);
                                displayedParticipants.add(participantFullName); // Ajouter le participant à l'ensemble
                            }
                        }
                    }
                }
            }
        }
        System.out.println();

        // Test
        // Modifier le champ d'un club
        collectionCompetitions.updateOne(Filters.eq("nom", "Le grand tour de table"), new Document("$set", new Document("lieux", "ça marche")));

        // 5. Alex
        System.out.println("Exercice 5 Alex");
        System.out.println("--------------");
        MongoCursor<Document> curs = collectionCompetitions.find(Filters.exists("participants")).cursor();
        List<Document> full_list = new ArrayList<>();
        while (curs.hasNext()) {
            List<Document> lst = (List) curs.next().get("participants");
            lst.forEach(c->{
                if (!full_list.contains(c)) {
                    full_list.add(c);
                }
            });
        }
        full_list.forEach(c->{
            System.out.println(c.get("nom") + " " + c.get("prenom"));
        });

    }
}
