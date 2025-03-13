/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 07-Triggers-Exemple.sql     Auteur : Ch. Stettler
Objet  : Exemple d'utilisation de trigger
---------------------------------------------------------------------------- */

-----------------------------------------------------------------------
-- Affichage d'un message dans le log à chaque suppression d'employé --
-----------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_delete_employe
   AFTER DELETE ON exe_employe
   FOR EACH ROW
BEGIN
   dbms_output.put_line('L''employé n° ' || :OLD.emp_no || ' (' || :old.emp_nom || ') a été supprimé !');
END;
/

SELECT * FROM exe_employe;
DELETE FROM exe_employe WHERE emp_no = 3;
SELECT * FROM exe_employe;
ROLLBACK;

---------------------------------------------------------------------------------------
-- Stocker toujours le nom du département en minuscule, avec l'initiale en majuscule --
---------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_dept_initcap
   BEFORE INSERT OR UPDATE OF dep_nom ON exe_dept
   FOR EACH ROW
BEGIN
   :NEW.dep_nom := INITCAP(:NEW.dep_nom);
END;
/

SELECT * FROM exe_dept;
INSERT INTO exe_dept VALUES (60, 'BDD');
UPDATE exe_dept SET dep_nom = 'informatique' WHERE dep_no = 4;
SELECT * FROM exe_dept;
ROLLBACK;
