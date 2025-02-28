/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 08-TriggerInsteadOf-Ex.sql  Auteur : Ch. Stettler
Objet  : Exemple d'utilisation des triggers INSTEAD OF sur les vues
---------------------------------------------------------------------------- */

/* ========================================================================= */

CREATE OR REPLACE VIEW vw_empl AS SELECT * FROM exe_employe LEFT JOIN exe_dept ON dep_no = emp_dep_no;
SELECT * FROM vw_empl;

UPDATE vw_empl SET emp_nom = 'Xxxx' WHERE emp_no = 2;       -- aucun soucis, modif possible
UPDATE vw_empl SET dep_nom = 'Xxxx' WHERE emp_no = 2;       -- modif impossible, car "table non protégée par clé" ou "jointure externe"

/* ========================================================================= */

-- Création d'un trigger pour les update sur cette vue
CREATE OR REPLACE TRIGGER trg_update_vw_empl
   INSTEAD OF UPDATE ON vw_empl
BEGIN
   NULL;
END trg_update_vw_empl;
/
-- dorénavant, tous les updates sur cette vue déclenchent ce trigger
UPDATE vw_empl SET emp_nom = 'Yyyy' WHERE emp_no = 2;       -- au lieu de faire l'update, Oracle lance le trigger
-- et comme ce trigger ne fait rien ==> aucune modification ne s'effectue !!
SELECT * FROM vw_empl;

/* ========================================================================= */

-- Il faut donc coder la mise-à-jour dans le trigger
CREATE OR REPLACE TRIGGER trg_update_vw_empl
   INSTEAD OF UPDATE ON vw_empl
BEGIN
   UPDATE exe_employe SET emp_nom = :NEW.emp_nom WHERE emp_no = :OLD.emp_no;
END trg_update_vw_empl;
/
-- dorénavant, tous les updates sur cette vue déclenchent le trigger
UPDATE vw_empl SET emp_nom    = 'Yyyy' WHERE emp_no = 2;       -- modif effectuée par le trigger
UPDATE vw_empl SET emp_prenom = 'Yyyy' WHERE emp_no = 2;       -- rien n'est modifié, le trigger ne modifiant pas ce champ !

/* ========================================================================= */

-- Création d'un trigger permettant de modifier le nom,prénom,salaire, ainsi que le nom du département
CREATE OR REPLACE TRIGGER trg_update_vw_empl
   INSTEAD OF UPDATE ON vw_empl
   FOR EACH ROW  -- optionnel pour les vues, car il s'agit dans tous les cas d'un trigger de ligne
BEGIN
   UPDATE exe_employe SET emp_nom = :NEW.emp_nom, emp_prenom = :NEW.emp_prenom, emp_salaire = :NEW.emp_salaire WHERE emp_no = :OLD.emp_no;
   IF :NEW.dep_nom <> :OLD.dep_nom THEN
      UPDATE exe_dept SET dep_nom = :NEW.dep_nom WHERE dep_no = :OLD.dep_no;  -- modifie le nom du Dépt (dans la table exe_dept)
   END IF;
END trg_update_vw_empl;
/
-- le nom du département est modifié pour tous les employés qui étaient dans celui-ci
UPDATE vw_empl SET dep_nom = 'Zzzz' WHERE emp_no = 2;
SELECT * FROM vw_empl;

/* ========================================================================= */

-- Au lieu de modifier le nom du dépt, on peut en créer un nouveau (s'il n'existe pas déjà)
CREATE OR REPLACE TRIGGER trg_update_vw_empl
   INSTEAD OF UPDATE ON vw_empl
DECLARE
   v_newNo exe_dept.dep_no%TYPE;
BEGIN
   UPDATE exe_employe SET emp_nom = :NEW.emp_nom, emp_prenom = :NEW.emp_prenom, emp_salaire = :NEW.emp_salaire, emp_dep_no = :NEW.emp_dep_no WHERE emp_no = :OLD.emp_no;
   IF :NEW.dep_nom <> :OLD.dep_nom THEN
      BEGIN
         SELECT dep_no INTO v_newNo FROM exe_dept WHERE UPPER(dep_nom) = UPPER(:NEW.dep_nom);
      EXCEPTION
         WHEN no_data_found THEN
            SELECT MAX(dep_no)+1 INTO v_newNo FROM exe_dept;
            INSERT INTO exe_dept VALUES(v_newNo, :NEW.dep_nom);
      END;
      UPDATE exe_employe SET emp_dep_no = v_newNo WHERE emp_no = :OLD.emp_no;
   END IF;
END trg_update_vw_empl;
/
-- Remarque: changement du nom du département
UPDATE vw_empl SET dep_nom = 'RH'   WHERE emp_no = 2;       -- changement de dépt, RH existe déjà
UPDATE vw_empl SET dep_nom = 'Aaaa' WHERE emp_no = 2;       -- création d'un nouveau dépt

/* ========================================================================= */

-- Généralement, on utilise des alias comme nom de champ des vues :
CREATE OR REPLACE VIEW vw_empl("N°", "Nom", "Prénom", "N°Dépt", "Dépt") AS
   SELECT emp_no, emp_nom, emp_prenom, emp_dep_no, dep_nom 
      FROM exe_employe LEFT JOIN exe_dept ON dep_no = emp_dep_no;
DROP TRIGGER trg_update_vw_empl;
SELECT * FROM vw_empl;
UPDATE vw_empl SET "Nom"    = 'Xxxx' WHERE "N°" = 2;
UPDATE vw_empl SET "Dépt"   = 'Truc' WHERE "N°" = 2;
UPDATE vw_empl SET "N°Dépt" = 5      WHERE "N°" = 2;

CREATE OR REPLACE TRIGGER trg_update_vw_empl
   INSTEAD OF UPDATE ON vw_empl
DECLARE
   v_newNo  exe_dept.dep_no%TYPE;
BEGIN
   UPDATE exe_employe SET emp_nom = :NEW."Nom", emp_prenom = :NEW."Prénom", emp_dep_no = :NEW."N°Dépt" WHERE emp_no = :OLD."N°";
   IF :NEW."Dépt" <> :OLD."Dépt" THEN
      BEGIN
         SELECT dep_no INTO v_newNo FROM exe_dept WHERE UPPER(dep_nom) = UPPER(:NEW."Dépt");
      EXCEPTION
         WHEN no_data_found THEN
            SELECT MAX(dep_no)+1 INTO v_newNo FROM exe_dept;
            INSERT INTO exe_dept VALUES(v_newNo, :NEW."Dépt");
      END;
      UPDATE exe_employe SET emp_dep_no = v_newNo WHERE emp_no = :OLD."N°";
   END IF;
END trg_update_vw_empl;
/
-- Remarque: utilisation des alias
UPDATE vw_empl SET "Nom"    = 'Aaaa' WHERE "N°" = 2;
UPDATE vw_empl SET "Dépt"   = 'Truc' WHERE "N°" = 2;
UPDATE vw_empl SET "N°Dépt" = 5      WHERE "N°" = 2;
SELECT * FROM vw_empl;

/* ========================================================================= */

CREATE OR REPLACE VIEW vw_empl("N°", "Nom", "Prénom", "N°Dépt", "Dépt") AS
   SELECT emp_no, emp_nom, emp_prenom, emp_dep_no, dep_nom 
      FROM exe_employe JOIN exe_dept ON dep_no = emp_dep_no
      WHERE emp_dep_no <> 1
   WITH CHECK OPTION;

-- Remarque: qu'en est-il des contraintes sur les vues : WITH READ ONLY & WITH CHECK OPTION ?
-- Que se passe-t-il ? Que faut-il faire ?
