CREATE OR REPLACE TRIGGER trg_new_livraison
  INSTEAD OF INSERT OR UPDATE OR DELETE ON vw_exa_livraison
  FOR EACH ROW
DECLARE
  v_mon_no          exa_montre.mon_no%TYPE;
  v_nb_liv          INTEGER;
BEGIN
  IF inserting THEN
    BEGIN
      SELECT mon_no INTO v_mon_no FROM exa_montre WHERE LOWER(mon_marque) = LOWER(:NEW."Marque") AND LOWER(mon_modele) = LOWER(:NEW."Modele");   
      SELECT COUNT(*) INTO v_nb_liv FROM exa_livraison WHERE liv_date = :NEW."Date" AND liv_mon_no = v_mon_no;
      IF v_nb_liv = 0 THEN
        INSERT INTO exa_livraison VALUES (:NEW."Date", v_mon_no, :NEW."Nombre");
      ELSE
        UPDATE exa_livraison SET liv_nombre = liv_nombre + :NEW."Nombre" WHERE liv_date = :NEW."Date" AND liv_mon_no = v_mon_no;
      END IF;
      UPDATE exa_montre SET mon_stock = mon_stock + :NEW."Nombre" WHERE mon_no = v_mon_no;
    EXCEPTION
      WHEN no_data_found THEN
        SELECT MAX(mon_no)+1 INTO v_mon_no FROM exa_montre;
        INSERT INTO exa_montre VALUES (v_mon_no, :NEW."Marque", :NEW."Modele", :NEW."Nombre", 0);
        INSERT INTO exa_livraison VALUES (:NEW."Date", v_mon_no, :NEW."Nombre");
    END;
  END IF;
END;
/
