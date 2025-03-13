CREATE OR REPLACE TRIGGER trg_delete_transport
  INSTEAD OF DELETE
  ON vw_exa_transports 
  FOR EACH ROW
DECLARE

BEGIN
  IF :OLD.statut <> 'T' THEN
    UPDATE exa_colis SET col_tra_no = NULL WHERE col_tra_no = :OLD.numero;
    DELETE exa_transport WHERE tra_no = :OLD.numero;
    dbms_output.put_line('Transport N° ' || :OLD.numero || ' a été supprimé');
    dbms_output.put_line('Colis N° ' || :OLD.no_colis || ' mis a jour');
  ELSE
    dbms_output.put_line('Impossible de supprimer le transport N° ' || :Old.numero || ' (déjà effectué)');
  END IF;
END trg_delete_transport;
/
