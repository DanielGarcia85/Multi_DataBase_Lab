create or replace package pkg_cinema_tp4 is

   PROCEDURE affiGenres (i_code_tri BOOLEAN);
   
   PROCEDURE affiFilm(i_gen_nom cin_genre.gen_nom%TYPE);

end pkg_cinema_tp4;
/
create or replace package body pkg_cinema_tp4 is

  PROCEDURE affiGenres (i_code_tri BOOLEAN) IS
    crs_gen SYS_REFCURSOR; 
    v_gen_nom cin_genre.gen_nom%TYPE;
    v_nb_gen NUMBER;
    v_rqt_sql VARCHAR2(500);
    err_false_param EXCEPTION;
    PRAGMA EXCEPTION_INIT(err_false_param, -06550);
  BEGIN
    v_rqt_sql := 'SELECT gen_nom, COUNT(est_gen_no) AS nb_film FROM cin_genre LEFT JOIN cin_estgenre ON gen_no = est_gen_no GROUP BY gen_nom';
    IF i_code_tri = TRUE THEN v_rqt_sql := v_rqt_sql || ' ORDER BY gen_nom';
    ELSE v_rqt_sql := v_rqt_sql || ' ORDER BY nb_film DESC, gen_nom';
    END IF;
    OPEN crs_gen FOR v_rqt_sql;
    FETCH crs_gen INTO v_gen_nom, v_nb_gen;   
    WHILE crs_gen%FOUND LOOP
      dbms_output.put(v_gen_nom || ' : ');
      IF v_nb_gen = 0 THEN dbms_output.put_line('aucun film !');
      ELSE dbms_output.put(v_nb_gen || ' films ==> '); affiFilm(v_gen_nom);
      END IF;
      FETCH crs_gen INTO v_gen_nom, v_nb_gen;
    END LOOP;
    CLOSE crs_gen;
  EXCEPTION
    WHEN err_false_param THEN dbms_output.put_line('ERREUR : mauvais paramètre d''entrée');
  END affiGenres;
  
  PROCEDURE affiFilm(i_gen_nom cin_genre.gen_nom%TYPE ) IS
    CURSOR crs_film IS SELECT fil_titre FROM cin_genre LEFT JOIN cin_estgenre ON gen_no = est_gen_no LEFT JOIN cin_film ON est_fil_no = fil_no WHERE gen_nom =i_gen_nom ORDER BY gen_nom;
    v_film crs_film%ROWTYPE;
  BEGIN
    OPEN crs_film;
    FETCH crs_film INTO v_film;
    WHILE crs_film%FOUND AND crs_film%ROWCOUNT<=3 LOOP
      dbms_output.put('<<'||v_film.fil_titre||'>> ');
      FETCH crs_film INTO v_film;
    END LOOP;
    dbms_output.new_line;
    CLOSE crs_film;
  END;

end pkg_cinema_tp4;
/
