CREATE OR REPLACE PACKAGE pkg_cinema IS
   PROCEDURE AfficherGenres(i_tri_nb IN BOOLEAN);
END pkg_cinema;
/
CREATE OR REPLACE PACKAGE BODY pkg_cinema IS

   PROCEDURE AfficherGenres(i_tri_nb IN BOOLEAN) IS
      csr_genres  SYS_REFCURSOR;
      v_tri       VARCHAR2(100);
      v_gen_no    cin_genre.gen_no%TYPE;
      v_gen_nom   cin_genre.gen_nom%TYPE;
      v_nb        INTEGER;
   BEGIN
      IF i_tri_nb THEN v_tri := 'COUNT(est_fil_no) DESC, '; END IF;
      OPEN csr_genres FOR 'SELECT gen_no, gen_nom, COUNT(est_fil_no) FROM cin_genre LEFT JOIN cin_estGenre ON est_gen_no=gen_no GROUP BY gen_no, gen_nom ORDER BY ' || v_tri || 'gen_nom';
      FETCH csr_genres INTO v_gen_no, v_gen_nom, v_nb;
      WHILE csr_genres%FOUND LOOP
         dbms_output.put(v_gen_nom || ': ');
         IF v_nb = 0 THEN
            dbms_output.put_line('aucun film !');
         ELSE
            dbms_output.put(v_nb || ' films ==> ');
            DECLARE
               CURSOR csr_films IS SELECT fil_titre FROM cin_film JOIN cin_estGenre ON est_fil_no=fil_no WHERE est_gen_no=v_gen_no AND ROWNUM<=3;
            BEGIN
               FOR v_film IN csr_films LOOP
                  dbms_output.put('«' || v_film.fil_titre || '» ');
               END LOOP;
               dbms_output.new_line;
            END;
         END IF;
         FETCH csr_genres INTO v_gen_no, v_gen_nom, v_nb;
      END LOOP;
      CLOSE csr_genres;
   END AfficherGenres;

END pkg_cinema;
/
BEGIN
   pkg_cinema.AfficherGenres(TRUE); dbms_output.new_line;
   pkg_cinema.AfficherGenres(FALSE);
END;
