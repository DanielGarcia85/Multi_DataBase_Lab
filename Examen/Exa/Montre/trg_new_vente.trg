CREATE OR REPLACE TRIGGER trg_new_vente
  BEFORE INSERT ON exa_vente
  FOR EACH ROW
DECLARE
  v_mon_no         exa_montre.mon_no%TYPE;
  v_mon_marque     exa_montre.mon_marque%TYPE;
  v_mon_modele     exa_montre.mon_modele%TYPE;
  v_mon_stock      exa_montre.mon_stock%TYPE;
BEGIN
    IF :NEW.ven_date > SYSDATE THEN
      RAISE_APPLICATION_ERROR(-20001, 'Date de vente incorrecte !');
    END IF;
    SELECT mon_no, mon_marque, mon_modele, mon_stock INTO v_mon_no, v_mon_marque, v_mon_modele, v_mon_stock FROM exa_montre WHERE mon_no = :NEW.ven_mon_no;
    IF v_mon_stock < 1 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Aucune ' || v_mon_marque || ' ' || v_mon_modele || ' en stock !');
    END IF;
    :NEW.ven_no :=  sq_exa_vente_no.NEXTVAL;
    UPDATE exa_montre SET mon_stock = mon_stock -1 WHERE mon_no = v_mon_no;
END;
/
