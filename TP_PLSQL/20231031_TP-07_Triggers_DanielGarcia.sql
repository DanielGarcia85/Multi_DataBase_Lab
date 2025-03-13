-----------------------------------------------------
-- N°1
-----------------------------------------------------
-- Vérification du contenu la table cin_type
SELECT * FROM cin_type;
/
-- Creation de la séquence
DECLARE
  max_typ_no cin_type.typ_no%TYPE;
  err_pas_de_seq EXCEPTION;
  PRAGMA EXCEPTION_INIT(err_pas_de_seq, -02289);
BEGIN
  SELECT MAX (typ_no)+1 INTO max_typ_no FROM cin_type;
  EXECUTE IMMEDIATE 'DROP SEQUENCE sq_Type';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_Type START WITH ' || max_typ_no || ' INCREMENT BY 1';
EXCEPTION
  WHEN err_pas_de_seq THEN EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_Type START WITH ' || max_typ_no || ' INCREMENT BY 1';
END;
/
-- Creation du Trigger qui génère automatiquement la clé primaire de la table cin_type à l'aide de la Séquence créé précédement
CREATE OR REPLACE TRIGGER trg_Insert_Type 
  BEFORE INSERT ON cin_type
  FOR EACH ROW
  WHEN (NEW.typ_no IS NULL)
BEGIN
  :NEW.typ_no:=sq_Type.nextval;
END;
/
-- Test
INSERT INTO cin_type (typ_nom) VALUES ('Court-métrage');
ROLLBACK;
/


-----------------------------------------------------
-- N°2
-----------------------------------------------------
-- Vérification du contenu la table cin_film
SELECT * FROM cin_film WHERE fil_no = 2;
/
-- Creation du Trigger qui inscrit dans les logs un message lorsqu'un film change de type
CREATE OR REPLACE TRIGGER trg_Changement_Type
  AFTER UPDATE OF fil_typ_no ON cin_film
  FOR EACH ROW
DECLARE
  v_old_typ_nom cin_type.typ_nom%TYPE;
  v_new_typ_nom cin_type.typ_nom%TYPE;
BEGIN
  dbms_output.put_line('Le film <<' || :NEW.fil_titre || '>> a changé de type :');
  dbms_output.put_line('**************************************');
  BEGIN
    SELECT typ_nom INTO v_old_typ_nom FROM cin_type WHERE typ_no = :OLD.fil_typ_no;
  EXCEPTION
    WHEN no_data_found THEN v_old_typ_nom := 'INCONNU';
  END;
  BEGIN
    SELECT typ_nom INTO v_new_typ_nom FROM cin_type WHERE typ_no = :NEW.fil_typ_no;
  EXCEPTION
    WHEN no_data_found THEN v_new_typ_nom := 'INCONNU';
  END;
  dbms_output.put_line('         Ancien Type  : ' || v_old_typ_nom);
  dbms_output.put_line('         Nouveau Type : ' || v_new_typ_nom);
END;
/
-- Test
UPDATE cin_film SET fil_typ_no = 2 WHERE fil_no = 2;
UPDATE cin_film SET fil_typ_no = 1 WHERE fil_no = 2;
UPDATE cin_film SET fil_typ_no = NULL WHERE fil_no = 2;
ROLLBACK;
/


-----------------------------------------------------
-- N°3
-----------------------------------------------------
-- Vérification du contenu la table cin_type
SELECT * FROM cin_type;
-- Creation du Trigger qui log les modifications dans la table cin_type
CREATE OR REPLACE TRIGGER trg_Update_Type
  AFTER UPDATE OF typ_nom ON cin_type
  FOR EACH ROW
DECLARE
  CURSOR crs_film IS SELECT fil_titre, fil_annee FROM cin_film WHERE fil_typ_no = :OLD.typ_no;
  TYPE T_FILM IS RECORD (titre cin_film.fil_titre%TYPE, annee cin_film.fil_annee%TYPE); 
  v_film T_FILM;
  nb_film INTEGER; 
BEGIN
  SELECT COUNT(*) INTO nb_film FROM cin_film WHERE fil_typ_no = :OLD.typ_no;
  OPEN crs_film;
  FETCH crs_film INTO v_film;
  dbms_output.put_line('Ces '||nb_film||' films ont changé de type (de '||:OLD.typ_nom|| ' à '||:NEW.typ_nom||') :');
  WHILE crs_film%FOUND LOOP
    dbms_output.put_line('- '||v_film.titre||' ('||v_film.annee||')');
    FETCH crs_film INTO v_film;
  END LOOP;
  CLOSE crs_film;
END;
/
--Test
UPDATE cin_type SET typ_nom='Docu' WHERE typ_no=2;
ROLLBACK;


