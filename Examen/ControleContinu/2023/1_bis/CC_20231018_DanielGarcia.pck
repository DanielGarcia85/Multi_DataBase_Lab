create or replace package cc_20231018_DanielGarcia is

  PROCEDURE afficherVentesDeCourges(i_annee cc_vente.ven_annee%TYPE, i_operateur VARCHAR2);

end cc_20231018_DanielGarcia;
/
create or replace package body cc_20231018_DanielGarcia is

  PROCEDURE afficherVentesDeCourges(i_annee cc_vente.ven_annee%TYPE, i_operateur VARCHAR2) IS
    CURSOR crs_annee_dispo IS SELECT ven_annee FROM cc_vente WHERE ven_nb IS NOT NULL GROUP BY ven_annee ORDER BY ven_annee DESC;
    v_annee_dispo VARCHAR2(200);
    v_vente_moy cc_vente.ven_nb%TYPE;
    v_vente_total cc_vente.ven_nb%TYPE;
    crs_vente SYS_REFCURSOR;
    v_rqt_sql VARCHAR2(200); 
    TYPE TYPE_COU_VEN_NB IS RECORD(cou_nom cc_courge.cou_nom%TYPE, ven_nb cc_vente.ven_nb%TYPE);
    v_vente TYPE_COU_VEN_NB;  
    err_operateur EXCEPTION;
  BEGIN  
    IF i_operateur != '<' OR i_operateur != '>' OR i_operateur != '=' OR i_operateur != '<=' OR i_operateur != '>=' OR i_operateur != '!=' THEN RAISE err_operateur; END IF;
    SELECT ROUND(AVG(ven_nb),0), ROUND(SUM(ven_nb),0) INTO v_vente_moy, v_vente_total FROM cc_vente WHERE ven_annee = i_annee;  
    IF v_vente_moy IS NULL THEN
      FOR r_annee_dispo IN crs_annee_dispo LOOP
        v_annee_dispo := v_annee_dispo || r_annee_dispo.ven_annee || ' ';
      END LOOP;
      raise_application_error(-20001, 'Aucune statistique pour ' || i_annee || ' ! Uniquement  pour les années ' || v_annee_dispo);
    END IF;  
    dbms_output.put_line('Moyenne des ventes de courges en ' || i_annee || ' : ' || v_vente_moy || ' pour un total de ' || v_vente_total || ' courges vendues.');
    v_rqt_sql := 'SELECT cou_nom, ven_nb FROM cc_courge JOIN cc_vente ON cou_no = ven_cou_no WHERE ven_annee = ' || i_annee || ' AND ven_nb ' || i_operateur ||' ' || v_vente_moy || ' ORDER BY cou_nom';
    OPEN crs_vente FOR v_rqt_sql;
    FETCH crs_vente INTO v_vente;  
    IF crs_vente%NOTFOUND THEN
      dbms_output.put_line('Pas de vente ' || i_operateur || ' à la moyenne en ' || i_annee);
    ELSE
      dbms_output.put_line('Liste des ventes ' || i_operateur || ' à la moyenne en ' || i_annee);
    END IF;   
    WHILE crs_vente%FOUND LOOP
      dbms_output.put('- ' || v_vente.ven_nb || ' ' || v_vente.cou_nom || ' (Historique :');
      DECLARE
        CURSOR crs_historique IS SELECT ven_annee, ven_nb FROM cc_vente JOIN cc_courge ON cou_no = ven_cou_no WHERE ven_nb IS NOT NULL AND cou_nom = v_vente.cou_nom ORDER BY ven_annee DESC;
      BEGIN
        FOR r_historique IN crs_historique LOOP
          dbms_output.put(' ' || r_historique.ven_annee || '=' || r_historique.ven_nb);
        END LOOP;
        dbms_output.put_line(')');
      END;
      FETCH crs_vente INTO v_vente;
    END LOOP;
    CLOSE crs_vente;
    dbms_output.new_line;
  EXCEPTION
    WHEN err_operateur THEN dbms_output.put_line('Opérateur ''' || i_operateur || ''' non valide');dbms_output.new_line;
  END afficherVentesDeCourges;

end cc_20231018_DanielGarcia;
/
