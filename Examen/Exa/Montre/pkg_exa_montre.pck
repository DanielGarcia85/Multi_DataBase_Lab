create or replace package pkg_exa_montre is

  PROCEDURE AfficherStat (i_mon_marque IN exa_montre.mon_marque%TYPE);
  PROCEDURE AfficherStat (i_mon_marque IN exa_montre.mon_marque%TYPE, i_tri IN BOOLEAN);

end pkg_exa_montre;
/
create or replace package body pkg_exa_montre is

  PROCEDURE AfficherStat (i_mon_marque IN exa_montre.mon_marque%TYPE) IS
  BEGIN
    AfficherStat(i_mon_marque, FALSE);
  END;

  PROCEDURE AfficherStat (i_mon_marque IN exa_montre.mon_marque%TYPE, i_tri IN BOOLEAN) IS
    v_nb_mon_no     INTEGER;
    c_modele        SYS_REFCURSOR;
    r_modele        exa_montre%ROWTYPE;
    v_rqt_sql_1     VARCHAR2(300);
    v_nb_ven        INTEGER;
    v_prix_moyen    INTEGER;
    c_vente         SYS_REFCURSOR;
    v_rqt_sql_2     VARCHAR2(300);
    r_date          exa_vente.ven_date%TYPE;
  BEGIN
    SELECT COUNT(mon_no) INTO v_nb_mon_no FROM exa_montre WHERE LOWER(mon_marque) = LOWER(i_mon_marque);
    IF v_nb_mon_no < 1 THEN
      dbms_output.put_line('Aucune montre de marque ' || i_mon_marque || ' !');
    ELSE
      v_rqt_sql_1 := 'SELECT * FROM exa_montre WHERE LOWER(mon_marque) = LOWER(''' || i_mon_marque || ''')';
      IF i_tri THEN
        v_rqt_sql_1 := v_rqt_sql_1 || ' ORDER BY mon_prix DESC';
      ELSE
        v_rqt_sql_1 := v_rqt_sql_1 || ' ORDER BY mon_modele';
      END IF;
      dbms_output.put_line('Statistique des ventes : ' || i_mon_marque);
      OPEN c_modele FOR v_rqt_sql_1;
      FETCH c_modele INTO r_modele;
      WHILE c_modele%FOUND LOOP
        SELECT COUNT(ven_no), AVG(ven_prix_vente) INTO v_nb_ven, v_prix_moyen FROM exa_vente WHERE ven_mon_no = r_modele.mon_no;
        dbms_output.put('- ' || r_modele.mon_modele || ' : ');
        IF v_nb_ven < 1 THEN
          dbms_output.put('aucune vente');  
        ELSE
          dbms_output.put(v_nb_ven || ' ventes au prix moyen de ' || v_prix_moyen || ' CHF aux dates suivantes : ');
          v_rqt_sql_2 := 'SELECT ven_date FROM exa_vente WHERE ven_mon_no = ' || r_modele.mon_no;
          OPEN c_vente FOR v_rqt_sql_2;
          FETCH c_vente INTO r_date;
          WHILE c_vente%FOUND LOOP
            dbms_output.put(r_date || ' ');
            FETCH c_vente INTO r_date;
          END LOOP;
          CLOSE c_vente;
        END IF;
        dbms_output.new_line;
        FETCH c_modele INTO r_modele;
      END LOOP;
      CLOSE c_modele;
    END IF;
  END AfficherStat;

end pkg_exa_montre;
/
