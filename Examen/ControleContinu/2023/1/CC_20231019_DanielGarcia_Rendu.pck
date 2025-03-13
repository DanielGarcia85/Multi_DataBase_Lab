create or replace package cc_20231019_DanielGarcia is

  PROCEDURE afficherVentesDeCourge(i_nom_courge cc_courge.cou_nom%TYPE);

end cc_20231019_DanielGarcia;
/
create or replace package body cc_20231019_DanielGarcia is

  PROCEDURE afficherVentesDeCourge(i_nom_courge cc_courge.cou_nom%TYPE) IS
    CURSOR crs_annee IS SELECT ven_annee FROM cc_vente GROUP BY ven_annee ORDER BY ven_annee DESC;
    CURSOR crs_courge IS SELECT cou_nom FROM cc_courge WHERE LOWER(cou_nom) LIKE LOWER(i_nom_courge||'%');
    CURSOR crs_tt_courge IS SELECT cou_nom FROM cc_courge;
    r_courge crs_courge%ROWTYPE;
    err_pas_de_courge EXCEPTION;
    TYPE TYPE_COURGE_VENDUE IS RECORD (cou_no cc_courge.cou_no%TYPE, cou_nom cc_courge.cou_nom%TYPE, ven_nb cc_vente.ven_nb%TYPE);
    v_courge_vendue TYPE_COURGE_VENDUE;
    v_vente_moy cc_vente.ven_nb%TYPE;
    v_vente_total cc_vente.ven_nb%TYPE;
    crs_courge_vend SYS_REFCURSOR;
    v_rqt_sql VARCHAR2(200);
  BEGIN
    IF i_nom_courge = 'xxx' THEN
      dbms_output.put_line('- Voici les variétés existantes : ');
      FOR r_tt_courge IN crs_tt_courge LOOP
        dbms_output.put_line(r_tt_courge.cou_nom);
      END LOOP;
    ELSE
      
      OPEN crs_courge;
      FETCH crs_courge INTO r_courge;
      IF crs_courge%NOTFOUND THEN RAISE err_pas_de_courge; END IF;
      WHILE crs_courge%FOUND LOOP
        dbms_output.put_line('Liste des ventes de ' || r_courge.cou_nom);
        FOR r_annee IN crs_annee LOOP
          dbms_output.put('- en ' || r_annee.ven_annee || ' : ');
          SELECT ROUND(AVG(ven_nb),0), ROUND(SUM(ven_nb),0) INTO v_vente_moy, v_vente_total FROM cc_vente WHERE ven_annee = r_annee.ven_annee;
          v_rqt_sql := 'SELECT pkg_cc_outils.MeilleureVente(' ||r_annee.ven_annee||') INTO v_courge_vendue FROM DUAL';
          
          dbms_output.put('Meilleur vente de l''année : ' || v_courge_vendue.cou_nom || ' = ' || v_courge_vendue.ven_nb);
          dbms_output.put_line(v_vente_moy || ' ' || v_vente_moy);
          --dbms_output.new_line;
        END LOOP;
        FETCH crs_courge INTO r_courge;
       END LOOP;
    CLOSE crs_courge;
    
    END IF;
    
    
    EXCEPTION
      WHEN err_pas_de_courge THEN dbms_output.put_line('Pas de courge commançant par les lettres <<' || UPPER(i_nom_courge) || '>>');
  END afficherVentesDeCourge; 

end cc_20231019_DanielGarcia;
/
