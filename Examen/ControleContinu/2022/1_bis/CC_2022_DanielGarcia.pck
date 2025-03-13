create or replace package cc_2022 is

  PROCEDURE QuiPeutJouerACetteDate (i_rep_date cc_representation.rep_date%TYPE);
  v_tri VARCHAR(20) := 'nb_joue';

end cc_2022;
/
create or replace package body cc_2022 is
  
  PROCEDURE QuiPeutJouerACetteDate (i_rep_date cc_representation.rep_date%TYPE) IS
    CURSOR crs_spe_this_date IS SELECT spe_nom FROM cc_representation JOIN cc_spectacle ON rep_spe_no = spe_no WHERE rep_date = i_rep_date;
    v_spe_this_date cc_spectacle.spe_nom%TYPE;
    err_no_spe_this_date EXCEPTION;
    err_rqt_sql EXCEPTION;
    PRAGMA EXCEPTION_INIT(err_rqt_sql, -00904);
  BEGIN
    OPEN crs_spe_this_date;
    FETCH crs_spe_this_date INTO v_spe_this_date;
    IF crs_spe_this_date%NOTFOUND THEN RAISE err_no_spe_this_date; END IF;
    WHILE crs_spe_this_date%FOUND LOOP
      dbms_output.put_line('Liste des comédiens ayant déjà joué "' || v_spe_this_date || '" !');
      DECLARE
        crs_com_this_spe SYS_REFCURSOR;
        v_rqt_sql VARCHAR2(500);
        v_com_this_spe cc_qui_a_joue_quoi%ROWTYPE;
        v_der_dat_rep cc_representation.rep_date%TYPE;
      BEGIN
        v_rqt_sql := 'SELECT * FROM cc_qui_a_joue_quoi WHERE spe_nom = ''' || v_spe_this_date || '''' || ' ORDER BY ' || v_tri;
        IF v_tri = 'nb_joue' THEN v_rqt_sql := v_rqt_sql || ' DESC'; END IF;
        OPEN crs_com_this_spe FOR v_rqt_sql;
        FETCH crs_com_this_spe INTO v_com_this_spe;
        IF crs_com_this_spe%NOTFOUND THEN
          dbms_output.put_line('==> Ce spectacle n''a encore jamais été joué');
        ELSE
          WHILE crs_com_this_spe%FOUND LOOP
            dbms_output.put('- ' || v_com_this_spe.com_nom || ' joue depuis ' || v_com_this_spe.com_debut || ' et a déjà joué ' || v_com_this_spe.nb_joue || ' ce spectacle');
            dbms_output.new_line;
            FETCH crs_com_this_spe INTO v_com_this_spe;
          END LOOP;
          CLOSE crs_com_this_spe;
          SELECT MAX(rep_date) INTO v_der_dat_rep FROM cc_representation JOIN cc_spectacle ON rep_spe_no = spe_no WHERE rep_date < SYSDATE AND spe_nom = v_spe_this_date;
          dbms_output.put_line('==> Dernière représentation de ce spectacle : ' || v_der_dat_rep);
        END IF;
      END; 
      dbms_output.new_line;                              
      FETCH crs_spe_this_date INTO v_spe_this_date;
    END LOOP;
    CLOSE crs_spe_this_date;
  EXCEPTION
    WHEN err_no_spe_this_date THEN dbms_output.put_line('Aucune représentation joué le ' || i_rep_date); dbms_output.new_line();
    WHEN err_rqt_sql THEN dbms_output.put_line('Il y a une erreur dans la requête SQL : Parmètre de tri invalide !'); dbms_output.new_line();
  END QuiPeutJouerACetteDate; 

end cc_2022;
/
