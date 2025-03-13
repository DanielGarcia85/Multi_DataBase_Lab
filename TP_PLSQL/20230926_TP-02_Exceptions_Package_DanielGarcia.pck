create or replace PACKAGE pkg_cinema_tp2 is

  -- Author  : DANIEL
  -- Created : 26.09.2023 19:28:53
  -- Purpose : 20230926_TP-2_Exceptions_DanielGarcia.pck
  
  PROCEDURE AfficherFilm (i_film_no IN cin_film.fil_no%TYPE);

END pkg_cinema_tp2;
/
create or replace package BODY pkg_cinema_tp2 is

  PROCEDURE AfficherFilm (i_film_no IN cin_film.fil_no%TYPE)IS
     
    v_typ_nom cin_type.typ_nom%TYPE;
    v_cin_film cin_film%ROWTYPE;
    v_nb_genre INTEGER;
    v_gen_nom cin_genre.gen_nom%TYPE;
    v_nb_mois_sortie INTEGER;
    v_nb_jour_sortie INTEGER;
    v_nb_film_meme_jour INTEGER;
    v_autre_film_meme_date cin_film.fil_titre%TYPE;
    
  BEGIN
    
    SELECT typ_nom INTO v_typ_nom FROM cin_type JOIN cin_film ON typ_no = fil_typ_no WHERE fil_no = i_film_no;
    SELECT * INTO v_cin_film FROM cin_film WHERE fil_no = i_film_no;
    dbms_output.put_line(v_typ_nom || ' ' || v_cin_film.fil_titre || ' :');
    -------------------
    IF v_cin_film.fil_duree IS NOT NULL THEN
      dbms_output.put_line('- durée : ' || v_cin_film.fil_duree);
    END IF;
    dbms_output.put_line('- réalisateur : ' || v_cin_film.fil_realis);
    -------------------
    /*SELECT COUNT(*) INTO v_nb_genre FROM cin_estgenre WHERE est_fil_no = i_film_no;
    IF v_nb_genre = 0 THEN
      dbms_output.put_line ('- genre non spécifié');
    END IF;
    IF v_nb_genre = 1 THEN
      SELECT gen_nom INTO v_gen_nom FROM cin_film JOIN cin_estgenre ON fil_no=est_fil_no JOIN cin_genre ON est_gen_no=gen_no WHERE fil_no = i_film_no;
      dbms_output.put_line ('- genre : ' || v_gen_nom);
    END IF;
    IF v_nb_genre >1 THEN
      dbms_output.put_line ('- plusieurs genres');
    END IF;*/
    --Il aurait été préférable de faire un nouveau bloc, afin de traiter l'exception : NO_DATA_FOUND et TOO_MANY_ROWS
    DECLARE
      v_gen_nom cin_genre.gen_nom%TYPE;
    BEGIN
      SELECT gen_nom INTO v_gen_nom FROM cin_genre JOIN cin_EstGenre ON gen_no = est_gen_no WHERE est_fil_no = v_cin_film.fil_no;
      dbms_output.put_line ('- genre : ' || v_gen_nom);
    EXCEPTION
      WHEN no_DATA_FOUND THEN dbms_output.put_line ('- genre non spécifié');
      WHEN TOO_MANY_ROWS THEN dbms_output.put_line ('- plusieurs genres');
    END;
    -------------------
    SELECT fil_sortie INTO v_cin_film.fil_sortie FROM cin_film WHERE fil_no = i_film_no;    
    SELECT MONTHS_BETWEEN(SYSDATE, v_cin_film.fil_sortie) INTO v_nb_mois_sortie FROM dual;
    SELECT TRUNC(SYSDATE - v_cin_film.fil_sortie) INTO v_nb_jour_sortie FROM dual;
    -- Pas besoin du TRUNC, Même résultat sans le TRUNC
    /*IF v_nb_mois_sortie > 2 THEN
      dbms_output.put_line('- il est sorti il y a ' || v_nb_mois_sortie ||' mois');
      ELSE IF v_nb_mois_sortie < 1 THEN
        dbms_output.put_line('- il sortira dans ' || -v_nb_jour_sortie ||' jours');
      ELSE
        dbms_output.put_line('- il est sorti il y a ' || v_nb_jour_sortie ||' jours');
      END IF;
    END IF;*/
    --Pareil il aurait fallu faire un bloc pour traiter 
    DECLARE
      v_ecart VARCHAR2(20);
    BEGIN
      IF ABS(MONTHS_BETWEEN(v_cin_film.fil_sortie, SYSDATE)) > 2 THEN
        v_ecart := ROUND(ABS(MONTHS_BETWEEN (v_cin_film.fil_sortie, SYSDATE))) || ' mois';
      ELSE
        v_ecart := ROUND(ABS(v_cin_film.fil_sortie - SYSDATE)) || ' jours';
      END IF;
      IF v_cin_film.fil_sortie < SYSDATE THEN
        dbms_output.put_line('- il est sorti il y a ' || v_ecart);
      ELSE
        dbms_output.put_line('- il est sortira dans ' || v_ecart);
      END IF;
    END;
    -------------------
    SELECT COUNT(*) INTO v_nb_film_meme_jour FROM cin_film WHERE fil_sortie = v_cin_film.fil_sortie;
    v_nb_film_meme_jour := v_nb_film_meme_jour - 1;
    IF v_nb_film_meme_jour < 1 THEN
      dbms_output.put_line('- aucun autre film sorti le ' || v_cin_film.fil_sortie);
      ELSE IF v_nb_film_meme_jour = 1 THEN
        SELECT fil_titre INTO v_autre_film_meme_date FROM cin_film WHERE fil_sortie = v_cin_film.fil_sortie AND fil_titre != v_cin_film.fil_titre;
        dbms_output.put_line('- seul autre film sorti le ' || v_cin_film.fil_sortie || ' : ' || v_autre_film_meme_date);
      ELSE
        dbms_output.put_line('- ' || v_nb_film_meme_jour || ' autres films sortis le ' || v_cin_film.fil_sortie);
      END IF;
    END IF;
    -------------------
    dbms_output.put_line('');
    -------------------
    EXCEPTION
      WHEN NO_DATA_FOUND THEN  dbms_output.put_line('Le film n° ' ||i_film_no|| ' n''existe pas !');
      dbms_output.put_line('');
      
  END AfficherFilm;
 
END pkg_cinema_tp2;
/
