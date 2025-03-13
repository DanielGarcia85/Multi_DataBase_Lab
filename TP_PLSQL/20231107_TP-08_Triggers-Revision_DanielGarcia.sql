ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY hh mi ss';
------------------------------------------------
--1)
------------------------------------------------
CREATE OR REPLACE VIEW vw_rev_lst_emplois AS
  SELECT per_no "N° personne", per_nom "Nom", per_prenom "Prénom", ent_no "N° entreprise", ent_nom "Entreprise", emp_date_debut "Date début", emp_salaire "Salaire"
  FROM rev_personne
  JOIN rev_emplois ON per_no = emp_per_no
  JOIN rev_entreprise ON emp_ent_no = ent_no
  ORDER BY "Nom", "Prénom", "Date début";

/
--Test
SELECT * FROM vw_rev_lst_emplois;

------------------------------------------------
--2)
------------------------------------------------
CREATE OR REPLACE TRIGGER trg_insert_rev_emplois
  INSTEAD OF INSERT ON vw_rev_lst_emplois
  FOR EACH ROW
DECLARE
  v_ent_no rev_entreprise.ent_no%TYPE;
BEGIN
  BEGIN
    SELECT ent_no INTO v_ent_no FROM rev_entreprise WHERE ent_no = :NEW."N° entreprise";
  EXCEPTION
    WHEN no_data_FOUND THEN
      INSERT INTO rev_entreprise VALUES (:NEW."N° entreprise", :NEW."Entreprise");
  END;
  INSERT INTO rev_emplois VALUES (:NEW."N° entreprise", :NEW."N° personne", :NEW."Date début", :NEW."Salaire");
END;
/
--Test
SELECT * FROM vw_rev_lst_emplois WHERE "N° personne" = 7;
INSERT INTO vw_rev_lst_emplois ("N° personne", "N° entreprise", "Date début", "Salaire") VALUES (7, 1, to_date('01-05-2020', 'dd-mm-yyyy'), 4000);
INSERT INTO vw_rev_lst_emplois ("N° personne", "N° entreprise", "Entreprise", "Date début", "Salaire") VALUES (7, 20, 'HEG-Genève', to_date('01-11-2021', 'dd-mm-yyyy'), 4000);
ROLLBACK;
COMMIT;

------------------------------------------------
--3)
------------------------------------------------
-- Creation de la séquence pour la table rev_statistique
DECLARE
  max_sta_no rev_statistique.sta_no%TYPE;
  err_pas_de_seq EXCEPTION;
  PRAGMA EXCEPTION_INIT(err_pas_de_seq, -02289);
BEGIN
  SELECT MAX (sta_no)+1 INTO max_sta_no FROM rev_statistique;
  EXECUTE IMMEDIATE 'DROP SEQUENCE sq_Sta';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_Sta START WITH ' || max_sta_no || ' INCREMENT BY 1';
EXCEPTION
  WHEN err_pas_de_seq THEN EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_Sta START WITH ' || max_sta_no || ' INCREMENT BY 1';
END pro_test;
/
-- Creation du Trigger qui tient à jour l'attribut sta_nb_change
CREATE OR REPLACE TRIGGER trg_insert_rev_domicile
  BEFORE INSERT ON rev_domicile
  FOR EACH ROW
DECLARE
  v_sta_nb_change rev_statistique.sta_nb_change%TYPE;
BEGIN
  SELECT sta_nb_change INTO v_sta_nb_change FROM rev_statistique WHERE sta_per_no = :NEW.dom_per_no;
  UPDATE rev_statistique SET sta_nb_change = v_sta_nb_change + 1  WHERE sta_per_no = :NEW.dom_per_no;
  UPDATE rev_domicile SET dom_date_depart = :NEW.dom_date_arrivee WHERE dom_per_no = :NEW.dom_per_no AND dom_date_depart IS NULL;
EXCEPTION
  WHEN no_data_found THEN
    INSERT INTO rev_statistique VALUES (sq_sta.Nextval, 1, 'Nouveau', :NEW.dom_per_no);
END;
/
--Test
SELECT * FROM rev_statistique;
SELECT * FROM rev_domicile ORDER BY dom_per_no, dom_date_arrivee;
SELECT * FROM rev_localite;
INSERT INTO rev_domicile VALUES (21, '01.04.2020', NULL, 10, 1);
INSERT INTO rev_domicile VALUES (22, '01.01.2021', NULL, 20, 1);
INSERT INTO rev_domicile VALUES (23, '01.12.2021', NULL, 22, 1);
INSERT INTO rev_domicile VALUES (24, '01.05.2020', NULL, 33, 5);
INSERT INTO rev_domicile VALUES (25, '01.11.2021', NULL, 44, 5);
ROLLBACK;

