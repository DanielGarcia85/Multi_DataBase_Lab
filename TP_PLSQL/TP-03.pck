create or replace package pkg_cinema_tp3 is

  PROCEDURE affiFilmsSelonType (i_typ_nom cin_type.typ_nom%TYPE);
  PROCEDURE affiFilmsSelonType;

end pkg_cinema_tp3;
/
create or replace package body pkg_cinema_tp3 is

  PROCEDURE affiFilmsSelonType (i_typ_nom cin_type.typ_nom%TYPE) IS
    CURSOR crs_film IS SELECT * FROM cin_film JOIN cin_type ON fil_typ_no = typ_no WHERE LOWER(typ_nom) = LOWER(i_typ_nom);
    r_film crs_film%ROWTYPE;
    filmNotFound EXCEPTION;
    nb_film_m_type INTEGER;
  BEGIN
    OPEN crs_film;
    FETCH crs_film INTO r_film;
    IF crs_film%NOTFOUND THEN
      RAISE filmNotFound;
    ELSE
      dbms_output.put_line('Listes des << ' || r_film.typ_nom || ' >> :');
      WHILE crs_film%FOUND AND crs_film%ROWCOUNT <= 5 LOOP
        dbms_output.put('- ' || r_film.fil_titre || ' (' || r_film.fil_duree || ') de ' || r_film.fil_realis || ', Genre:');
        DECLARE
          CURSOR crs_genre IS SELECT gen_nom FROM cin_genre JOIN cin_estgenre ON gen_no = est_gen_no WHERE est_fil_no = r_film.fil_no;
        BEGIN
          FOR r_genre IN crs_genre LOOP
            dbms_output.put(' ' ||r_genre.gen_nom);
          END LOOP;
        END;
        dbms_output.new_line;
        FETCH crs_film INTO r_film;
      END LOOP;
      SELECT COUNT(*)-5 INTO nb_film_m_type FROM cin_type JOIN cin_film ON typ_no = fil_typ_no WHERE LOWER(typ_nom) = LOWER(i_typ_nom);
      IF nb_film_m_type > 0 THEN
        dbms_output.put_line('... ainsi que ' || nb_film_m_type || ' autres ' || r_film.typ_nom);
      END IF;
      CLOSE crs_film;
    END IF;
    EXCEPTION
      WHEN filmNotFound THEN dbms_output.put_line('Le type de film << ' || i_typ_nom || ' >> n''existe pas !');
  END affiFilmsSelonType;

  PROCEDURE affiFilmsSelonType IS
    CURSOR crs_type IS SELECT typ_nom FROM cin_type;
  BEGIN
    FOR r_type IN crs_type LOOP
      affiFilmsSelonType(r_type.typ_nom);
      dbms_output.new_line;
    END LOOP;
  END affiFilmsSelonType;

end pkg_cinema_tp3;
/
