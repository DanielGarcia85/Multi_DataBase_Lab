create or replace package pkg_cinema_tp3 IS

PROCEDURE AffiFilmSelonType(v_typ_nom IN cin_type.typ_nom%TYPE);
PROCEDURE AffiFilmSelonType;
  

end pkg_cinema_tp3;
/
create or replace package body pkg_cinema_tp3 IS

  PROCEDURE AffiFilmSelonType(v_typ_nom IN cin_type.typ_nom%TYPE) IS
    CURSOR crs_film IS SELECT * FROM cin_film JOIN cin_type ON fil_typ_no = typ_no WHERE LOWER(typ_nom) = LOWER(v_typ_nom);
    v_film crs_film%ROWTYPE;
    v_nb_film_restant INTEGER;
  BEGIN
    OPEN crs_film;
    FETCH crs_film INTO v_film;
    IF crs_film%NOTFOUND THEN
      dbms_output.put_line('Il n''y a pas de film de type : << '||v_typ_nom||' >>');
    ELSE
      dbms_output.put_line('Liste des << ' ||v_film.typ_nom||' >> :');
      WHILE crs_film%FOUND AND crs_film%ROWCOUNT <= 5 LOOP
          dbms_output.put(' - '||v_film.fil_titre||' ('||v_film.fil_duree||') de '||v_film.fil_realis||', Genre: ');
          DECLARE
            CURSOR crs_genre IS SELECT * FROM cin_genre JOIN cin_estgenre ON gen_no=est_gen_no WHERE est_fil_no = v_film.fil_no;
            v_genre crs_genre%ROWTYPE;
          BEGIN
            OPEN crs_genre;
            FETCH crs_genre INTO v_genre;
            WHILE crs_genre%FOUND LOOP
              dbms_output.put(v_genre.gen_nom||' ');
              FETCH crs_genre INTO v_genre;
            END LOOP;
            dbms_output.put_line('');
            CLOSE crs_genre;
          END;
          FETCH crs_film INTO v_film;
      END LOOP;  
      IF crs_film%FOUND THEN
        SELECT COUNT(*) INTO v_nb_film_restant FROM cin_film JOIN cin_type ON fil_typ_no = typ_no WHERE LOWER(typ_nom) = LOWER(v_typ_nom);
        v_nb_film_restant:=v_nb_film_restant-5;
        dbms_output.put_line('... ainsi que '||v_nb_film_restant||' autres '||v_film.typ_nom);
      END IF;
    CLOSE crs_film;
    END IF;
    dbms_output.put_line('');
  END AffiFilmSelonType;
  
  -------------
  
  PROCEDURE AffiFilmSelonType IS
    CURSOR c_type IS SELECT * FROM cin_type;
    r_type c_type%ROWTYPE;
  BEGIN
    OPEN c_type;
    FETCH c_type INTO r_type;
    WHILE c_type%FOUND LOOP
      AffiFilmSelonType(r_type.typ_nom);
      FETCH c_type INTO r_type;
    END LOOP;
    CLOSE c_type;
    dbms_output.put_line('');
  END AffiFilmSelonType;
  
  /*PROCEDURE AffiFilmSelonType IS
    CURSOR crs_film_type IS SELECT * FROM cin_type ORDER BY typ_nom;
    CURSOR crs_film IS SELECT * FROM cin_film JOIN cin_type ON fil_typ_no=typ_no;
    v_film_type crs_film_type%ROWTYPE;
    v_film crs_film%ROWTYPE;
    v_nb_film INTEGER;
    v_nb_film_restant INTEGER;
  BEGIN
    OPEN crs_film_type;
    FETCH crs_film_type INTO v_film_type;
    WHILE crs_film_type%FOUND LOOP
      dbms_output.put_line('Liste des film : << '||v_film_type.typ_nom||' >> :');
      v_nb_film:=0;
      OPEN crs_film;
      FETCH crs_film INTO v_film;
      WHILE crs_film%FOUND LOOP
        IF v_film_type.typ_no = v_film.typ_no AND v_nb_film < 5 THEN
          DECLARE
            CURSOR crs_genre IS SELECT * FROM cin_genre JOIN cin_estgenre ON gen_no=est_gen_no WHERE est_fil_no = v_film.fil_no;
            v_genre crs_genre%ROWTYPE;
          BEGIN
            OPEN crs_genre;
            FETCH crs_genre INTO v_genre;
            dbms_output.put(' - '||v_film.fil_titre||' ('||v_film.fil_duree||') de '||v_film.fil_realis||', Genre: ');
            WHILE crs_genre%FOUND LOOP
              dbms_output.put(v_genre.gen_nom||' ');
              FETCH crs_genre INTO v_genre;
            END LOOP;
            dbms_output.put_line('');
            CLOSE crs_genre;
          END;    
          v_nb_film:=v_nb_film+1;
        END IF;  
        FETCH crs_film INTO v_film;
      END LOOP;
      SELECT COUNT(*) INTO v_nb_film_restant FROM cin_film JOIN cin_type ON fil_typ_no = typ_no WHERE typ_nom = v_film_type.typ_nom;
        v_nb_film_restant:=v_nb_film_restant-5;
        IF v_nb_film_restant>0 THEN
          dbms_output.put_line('-... ainsi que '||v_nb_film_restant||' autres '||v_film_type.typ_nom);
        END IF;
      CLOSE crs_film;
      dbms_output.put_line('');
      FETCH crs_film_type INTO v_film_type;
    END LOOP;
    CLOSE crs_film_type;
  END AffiFilmSelonType;*/

end pkg_cinema_tp3;
/
