CREATE OR REPLACE TRIGGER trg_new_transport
  INSTEAD OF INSERT
  ON vw_exa_transports 
  FOR EACH ROW
DECLARE
  c_colis         SYS_REFCURSOR;
  r_colis         exa_colis%ROWTYPE;
  v_rqt_sql       VARCHAR2(300);
  v_nb_colis      INTEGER;
  v_poids_total   INTEGER;
  v_agence        VARCHAR2(20);
BEGIN
  SELECT COUNT(*) INTO v_nb_colis FROM exa_colis WHERE col_age_depart = :NEW.depart AND col_age_arrivee = :NEW.arrivee AND col_tra_no is NULL;
  IF v_nb_colis <> 0 THEN
    v_rqt_sql := 'SELECT * FROM exa_colis WHERE col_age_depart = ' || :NEW.depart || ' AND col_age_arrivee = ' || :NEW.arrivee || ' AND col_tra_no is NULL';
    IF v_nb_colis < 10 THEN
      v_rqt_sql := v_rqt_sql || ' ORDER BY col_poids DESC';
    ELSE 
      v_rqt_sql := v_rqt_sql || ' ORDER BY col_no';
    END IF;
    OPEN c_colis FOR v_rqt_sql;
    FETCH c_colis INTO r_colis;
    v_poids_total := r_colis.col_poids; 
    INSERT INTO exa_transport VALUES (NULL, :NEW.poids_max, 'P', :NEW.depart, :NEW.arrivee);
    WHILE c_colis%FOUND LOOP
      IF v_poids_total <= :NEW.poids_max THEN
        UPDATE exa_colis SET col_tra_no = sq_exa_transport_no.currval WHERE col_age_depart = :NEW.depart AND col_age_arrivee = :NEW.arrivee AND col_tra_no is NULL AND col_no = r_colis.col_no;
        dbms_output.put_line('Le colis N� ' || r_colis.col_no || ' a �t� ajout� au transport ' || sq_exa_transport_no.currval);
      ELSE
        v_agence := 'exa_log_agence_' || :NEW.depart;
        EXECUTE IMMEDIATE 'INSERT INTO ' || v_agence || ' VALUES(''TROP LOURD : Le colis N�' || r_colis.col_no || ' n''''a pas �t� ajout� au transport N� ' || sq_exa_transport_no.currval ||''')';
        dbms_output.put_line('TROP LOURD : Le colis N� ' || r_colis.col_no || ' n''a pas �t� ajout� au transport ' || sq_exa_transport_no.currval);
      END IF;
      FETCH c_colis INTO r_colis;
      v_poids_total := v_poids_total + r_colis.col_poids;
    END LOOP;
    CLOSE c_colis; 
  ELSE
    dbms_output.put_line('Aucun colis sans num�ro de transport ne correspond au d�part-arriv� inser�');
  END IF;
  
  
END trg_new_transport;
/
