/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 02-Exceptions-TP.sql        Auteur : Ch. Stettler
Objet  : TP cinéma sur SELECT INTO et traitement des exceptions
---------------------------------------------------------------------------- */

CREATE OR REPLACE PACKAGE pkg_cinema IS
   PROCEDURE AfficherFilm(i_fil_no IN cin_film.fil_no%TYPE);
END pkg_cinema;
/
CREATE OR REPLACE PACKAGE BODY pkg_cinema IS

   PROCEDURE AfficherFilm(i_fil_no IN cin_film.fil_no%TYPE) IS
      v_film        cin_film%ROWTYPE;
      v_type        cin_type%ROWTYPE;
      v_écart       VARCHAR2(10);
      v_nb          NUMBER;
      v_fil_titre   cin_film.fil_titre%TYPE;
   BEGIN
      SELECT * INTO v_film FROM cin_film WHERE fil_no = i_fil_no;
      SELECT * INTO v_type FROM cin_type WHERE typ_no = v_film.fil_typ_no;
      dbms_output.put_line(v_type.typ_nom || ' ' || v_film.fil_titre || ' :');
      IF v_film.fil_duree IS NOT NULL THEN
         dbms_output.put_line('- durée : ' || v_film.fil_duree);
      END IF;
      dbms_output.put_line('- réalisateur : ' || v_film.fil_realis);

      DECLARE
         v_gen_nom  cin_genre.gen_nom%TYPE;
      BEGIN
         SELECT gen_nom INTO v_gen_nom FROM cin_estGenre JOIN cin_genre ON gen_no=est_gen_no WHERE est_fil_no=v_film.fil_no;
         dbms_output.put_line('- genre : ' || v_gen_nom);
      EXCEPTION
         WHEN no_data_found THEN dbms_output.put_line('- genre non spécifié');
         WHEN too_many_rows THEN dbms_output.put_line('- plusieurs genres');
      END;

      IF ABS(MONTHS_BETWEEN(v_film.fil_sortie, SYSDATE)) > 2 THEN
         v_écart := ROUND(ABS(MONTHS_BETWEEN(v_film.fil_sortie, SYSDATE))) || ' mois';
      ELSE
         v_écart := ROUND(ABS(v_film.fil_sortie - SYSDATE)) || ' jours';
      END IF;
      IF v_film.fil_sortie < SYSDATE THEN
         dbms_output.put_line('- il est sorti il y a ' || v_écart);
      ELSE
         dbms_output.put_line('- il sortira dans ' || v_écart);
      END IF;

      SELECT COUNT(*) INTO v_nb FROM cin_film WHERE fil_sortie = v_film.fil_sortie;
      IF v_nb = 1 THEN
         dbms_output.put_line('- aucun autre film sorti le ' || v_film.fil_sortie);
      ELSIF v_nb > 2 THEN
         dbms_output.put_line('- ' || (v_nb-1) || ' autres films sortis le ' || v_film.fil_sortie);
      ELSE
         SELECT fil_titre INTO v_fil_titre FROM cin_film WHERE fil_sortie = v_film.fil_sortie AND fil_no <> v_film.fil_no;
         dbms_output.put_line('- seul autre film sorti le ' || v_film.fil_sortie || ' : ' || v_fil_titre);
      END IF;
      dbms_output.new_line;
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line('Le film n° ' || i_fil_no || ' n''existe pas !');
   END AfficherFilm;
END pkg_cinema;
/

/************************************************************/
/* Jeux de tests                                            */
/************************************************************/

BEGIN
   pkg_cinema.AfficherFilm(20);  -- genre : Thriller     estSorti jours   2 autres films
   pkg_cinema.AfficherFilm(30);  -- genre non spécifié   estSorti jours   4 autres films
   pkg_cinema.AfficherFilm(60);  -- genre : Portrait     sortira  jours   4 autres films
   pkg_cinema.AfficherFilm(10);  -- plusieurs genres     estSorti mois    seul autre film
   pkg_cinema.AfficherFilm(29);  -- plusieurs genres     estSorti jours   aucun
   pkg_cinema.AfficherFilm(99);  -- n'existe pas
END;
