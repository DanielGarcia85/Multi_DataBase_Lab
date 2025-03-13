create or replace package cc_20231019_DanielGarcia is

  PROCEDURE afficherVentesDeCourge(i_nom_courge cc_courge.cou_nom%TYPE);
  FUNCTION tte_les_courges RETURN VARCHAR2;

end cc_20231019_DanielGarcia;
/
create or replace package body cc_20231019_DanielGarcia is
 
  PROCEDURE afficherVentesDeCourge(i_nom_courge cc_courge.cou_nom%TYPE) IS
    CURSOR crs_courge IS SELECT cou_nom FROM cc_courge WHERE lower(cou_nom) LIKE lower(i_nom_courge||'%');
    v_courge crs_courge%ROWTYPE;
    crs_annee SYS_REFCURSOR;
    v_rqt_sql VARCHAR2(200);
    v_annee cc_vente.ven_annee%TYPE; 
  BEGIN   
    OPEN crs_courge;
    FETCH crs_courge INTO v_courge;  
    IF crs_courge%NOTFOUND THEN raise_application_error(-20001, 'Voici les variété existantes : '|| tte_les_courges); END IF;
    WHILE crs_courge%FOUND LOOP
      dbms_output.put_line('Liste des ventes de ' || v_courge.cou_nom || ' :');
      v_rqt_sql := 'SELECT ven_annee FROM cc_vente JOIN cc_courge ON cou_no = ven_cou_no WHERE cou_nom = ''' || v_courge.cou_nom || ''' GROUP BY ven_annee ORDER BY ven_annee DESC';
      OPEN crs_annee FOR v_rqt_sql;
      FETCH crs_annee INTO v_annee;
      WHILE crs_annee%FOUND LOOP
        dbms_output.put('- en '|| v_annee || ' : ');
        DECLARE
          v_nb_vente cc_vente.ven_nb%TYPE;
          v_total_vente_annee cc_vente.ven_nb%TYPE;
          v_meilleure_vente pkg_cc_outils.TYPE_COURGE_VENDUE;        
        BEGIN         
          v_meilleure_vente := pkg_cc_outils.MeilleureVente(v_annee);
          SELECT ven_nb INTO v_nb_vente FROM cc_vente JOIN cc_courge ON cou_no = ven_cou_no WHERE cou_nom = v_courge.cou_nom AND ven_annee = v_annee;
          SELECT SUM(ven_nb) INTO v_total_vente_annee FROM cc_vente WHERE ven_annee = v_annee GROUP BY ven_annee;
          dbms_output.put_line(v_nb_vente || ' (meilleure vente de l''année : ' || v_meilleure_vente.cou_nom || ' = ' || v_meilleure_vente.ven_nb || ', total des ventes = ' || v_total_vente_annee);
        EXCEPTION
          WHEN pkg_cc_outils.AucuneVenteCetteAnnee THEN dbms_output.put_line('aucune vente pour cette année !');
        END;       
        FETCH crs_annee INTO v_annee;
      END LOOP;
      CLOSE crs_annee;
      FETCH crs_courge INTO v_courge;
      dbms_output.new_line;
    END LOOP;
    CLOSE crs_courge;
  END afficherVentesDeCourge;
  
  FUNCTION tte_les_courges RETURN VARCHAR2 IS
    CURSOR crs_tte_les_courges IS SELECT cou_nom FROM cc_courge;
    v_tte_les_courges VARCHAR2(200);
  BEGIN
    FOR r_tte_les_courges IN crs_tte_les_courges LOOP v_tte_les_courges := v_tte_les_courges || r_tte_les_courges.cou_nom || ' '; END LOOP;
    RETURN v_tte_les_courges;
  END tte_les_courges;
  
end cc_20231019_DanielGarcia;
/
