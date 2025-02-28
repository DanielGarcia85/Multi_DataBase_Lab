CREATE OR REPLACE TRIGGER trg_update_transport
  INSTEAD OF UPDATE
  ON vw_exa_transports 
  FOR EACH ROW
BEGIN
  IF :OLD.statut = 'T' THEN
    UPDATE exa_transport SET tra_statut = :NEW.statut WHERE tra_no = :NEW.numero;
    dbms_output.put_line('Le statut du transport N° ' || :NEW.Numero || ' est : <<Terminé>>. Aucune modif possible');
    dbms_output.put_line('Son nouveau statut est : ' || :NEW.statut);
    dbms_output.new_line;
  ELSE
    UPDATE exa_transport SET tra_poids_max = :NEW.poids_max, tra_statut = :NEW.statut, tra_age_depart = :NEW.depart, tra_age_arrivee = :NEW.arrivee WHERE tra_no = :NEW.numero;
    UPDATE exa_colis SET col_poids = :NEW.poids_colis, col_age_depart = :NEW.depart, col_age_arrivee = :NEW.arrivee, col_tra_no = :NEW.numero WHERE col_no = :NEW.no_colis; 
    dbms_output.put_line('Le transport N° ' || :NEW.numero || ' a été modifié'); 
    dbms_output.put_line('Le colis N° ' || :NEW.no_colis || ' a été modifié'); 
  END IF;
END trg_update_transport;
/
