create or replace package pkg_cinema_tp4 is

  PROCEDURE affiGenres(v_tri BOOLEAN);

end pkg_cinema_tp4;
/
create or replace package body pkg_cinema_tp4 is

  PROCEDURE affiGenres(v_tri BOOLEAN) IS
    CURSOR crs_genre IS SELECT * FROM cin_genre;
    v_genre crs_genre%ROWTYPE;
  BEGIN
    FOR r_genre IN crs_genre LOOP
      dbms_output.put(r_genre.gen_nom || ' : ');
      DECLARE
        CURSOR crs_film IS SELECT * FROM cin_film JOIN cin_estgenre ON fil_no = est_fil_no WHERE est_gen_no = r_genre.gen_no;
        v_film crs_film%ROWTYPE;
        v_nb_film INTEGER;
      BEGIN
        OPEN crs_film;
        FETCH crs_film INTO v_film;
        IF crs_film%NOTFOUND THEN
          dbms_output.put('aucun film ! ');
        ELSE
          SELECT COUNT(*) INTO v_nb_film FROM cin_film JOIN cin_estgenre ON fil_no = est_fil_no WHERE est_gen_no = r_genre.gen_no;
          dbms_output.put(v_nb_film || ' films ==> ');
          WHILE crs_film%FOUND AND crs_film%ROWCOUNT <= 3 LOOP
            dbms_output.put('<<' || v_film.fil_titre || '>> ');
            FETCH crs_film INTO v_film;
          END LOOP;
        CLOSE crs_film;
        END IF;
      END;
        dbms_output.new_line;
    END LOOP;
  END affiGenres;

end pkg_cinema_tp4;
/
