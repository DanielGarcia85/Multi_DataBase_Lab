create or replace package pkg_cinema_tp2 is

PROCEDURE afficherFilm (i_fil_no cin_film.fil_no%TYPE);

end pkg_cinema_tp2;
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

create or replace package body pkg_cinema_tp2 is
  
PROCEDURE afficherFilm (i_fil_no cin_film.fil_no%TYPE) IS
  v_film cin_film%ROWTYPE;
  v_type cin_type%ROWTYPE;
  v_ecart VARCHAR2(50);
  v_nb_film INTEGER;
  v_fil_titre cin_film.fil_titre%TYPE;
BEGIN
  SELECT * INTO v_film FROM cin_film WHERE fil_no = i_fil_no;
  SELECT * INTO v_type FROM cin_type WHERE typ_no = v_film.fil_typ_no;
  dbms_output.put_line(v_type.typ_nom || ' ' || v_film.fil_titre);
  IF v_film.fil_duree IS NOT NULL THEN
    dbms_output.put_line('- durée : ' || v_film.fil_duree);
  END IF;
  dbms_output.put_line('- réalisateur : ' || v_film.fil_realis);
  DECLARE
    v_gen_nom cin_genre.gen_nom%TYPE;
  BEGIN
    SELECT gen_nom INTO v_gen_nom FROM cin_genre JOIN cin_estgenre ON gen_no = est_gen_no WHERE est_fil_no = v_film.fil_no;
    dbms_output.put_line('- genre : ' || v_gen_nom);
  EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('- genre non spécifié');
    WHEN too_many_rows THEN dbms_output.put_line('- plusieurs genres');
  END;
  IF ABS(MONTHS_BETWEEN(v_film.fil_sortie, SYSDATE))>2 THEN 
    v_ecart := ROUND(ABS(MONTHS_BETWEEN(v_film.fil_sortie, SYSDATE))) || ' mois';
  ELSE
    v_ecart := ROUND(ABS(v_film.fil_sortie - SYSDATE)) || ' jours';
  END IF;
  IF v_film.fil_sortie < SYSDATE THEN
    dbms_output.put_line('- il est sorti il y a ' || v_ecart);
  ELSE
    dbms_output.put_line('- il sortira dans ' || v_ecart);
  END IF;
  SELECT COUNT(fil_no) INTO v_nb_film FROM cin_film WHERE fil_sortie= v_film.fil_sortie;
  v_nb_film := v_nb_film - 1;
  IF v_nb_film < 1 THEN dbms_output.put_line('- aucun autre film sorti le ' || v_film.fil_sortie);
  ELSIF v_nb_film = 1 THEN
    SELECT fil_titre INTO v_fil_titre FROM cin_film WHERE fil_sortie = v_film.fil_sortie AND fil_titre != v_film.fil_titre;
    dbms_output.put_line('- seul un autre film sorti le ' || v_film.fil_sortie || ' ' || v_fil_titre);
  ELSE
    dbms_output.put_line(v_nb_film || ' autres films sortis le ' || v_film.fil_sortie);
  END IF;
  dbms_output.new_line;
EXCEPTION 
  WHEN no_data_found THEN dbms_output.put_line('Le film n° ' || i_fil_no || ' n''existe pas !');
  dbms_output.new_line;
END afficherFilm;

end pkg_cinema_tp2;
/
