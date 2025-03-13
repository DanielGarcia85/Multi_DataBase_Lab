/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 03-PragmaExceptionInit.sql  Auteur : Ch. Stettler
Objet  : Exemple d'utilisation de PRAGMA EXCEPTION_INIT
---------------------------------------------------------------------------- */

CREATE OR REPLACE PACKAGE pkg_employe IS
   PROCEDURE MajSalaire(i_emp_no IN exe_employe.emp_no%TYPE, i_emp_salaire IN exe_employe.emp_salaire%TYPE);
END pkg_employe;
/
CREATE OR REPLACE PACKAGE BODY pkg_employe IS

   check_constraint_violated EXCEPTION;                      -- définition d'une nouvelle exception (le nom est libre)
   PRAGMA EXCEPTION_INIT(check_constraint_violated, -2290);  -- -2290 est le n° d'exception déclenché en cas d'erreur d'une CONSTRAINT CHECK 
                                                             -- PRAGMA EXCEPTION_INIT permet d'associer le n° d'erreur -2290 à l'exception nommée check_constraint_violated
   PROCEDURE MajSalaire(i_emp_no IN exe_employe.emp_no%TYPE, i_emp_salaire IN exe_employe.emp_salaire%TYPE) IS
   BEGIN
      UPDATE exe_employe SET emp_salaire = i_emp_salaire WHERE emp_no = i_emp_no;
      dbms_output.put_line('Salaire modifié');
   EXCEPTION
      WHEN check_constraint_violated THEN                    -- cela permet d'attraper des EXCEPTIONS qui ne sont pas nommées (qui n'ont pas de nom officiel, mais juste un code d'erreur)
         dbms_output.put_line('Erreur sur une contrainte de CHECK définie sur la table ! code=' || SQLCODE || ' / errm=' || SQLERRM);
   END MajSalaire;
   
END pkg_employe;
/
BEGIN
   pkg_employe.MajSalaire(2,  4444);
   pkg_employe.MajSalaire(2, -4444);
END;
/
SELECT * FROM exe_employe;
