/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 02-Raise-Exemple.sql        Auteur : Ch. Stettler
Objet  : Exemple de d�clenchement d'exception avec RAISE et RAISE_APPLICATION_ERROR
---------------------------------------------------------------------------- */

CREATE OR REPLACE PACKAGE pkg_exemple IS
   FUNCTION SalaireAnnuel(i_emp_no IN exe_employe.emp_no%TYPE) RETURN NUMBER;
END pkg_exemple;
/
CREATE OR REPLACE PACKAGE BODY pkg_exemple IS
   pasDansUnDepartement  EXCEPTION;

   FUNCTION SalaireAnnuel(i_emp_no IN exe_employe.emp_no%TYPE) RETURN NUMBER IS
      v_employe exe_employe%ROWTYPE;
   BEGIN
      SELECT * INTO v_employe FROM exe_employe WHERE emp_no = i_emp_no;
      
      IF v_employe.emp_dep_no IS NULL THEN
         RAISE pasDansUnDepartement;     -- TRAITEMENT SP�CIAL si l'employ� n'est pas affect� � un d�partement
      END IF;                            -- cette EXCEPTION sera attrap�e/trait�e quelque part en PL/SQL
      
      IF v_employe.emp_salaire IS NULL THEN
         RAISE_APPLICATION_ERROR(-20000, 'Salaire mensuel inconnu !'); -- ERREUR (retourn�e � l'appli) si pas de salaire
      END IF;                            -- cette EXCEPTION ne sera pas attrap�e/trait�e en PL/SQL, mais retourn�e au pgm (Java/Python/PHP)
      
      RETURN v_employe.emp_salaire * 13; -- par d�faut, les employ�s (dans un d�partement) ont un 13�me salaire
      
   EXCEPTION
      WHEN pasDansUnDepartement THEN RETURN v_employe.emp_salaire * 12; -- si l'employ� n'est pas affect� � un d�pt, salaire*12
   END SalaireAnnuel;
END pkg_exemple;
/

-- Test
BEGIN
   dbms_output.put_line('Salaire annuel de l''employ� n� 9 : ' || pkg_exemple.SalaireAnnuel(9));
   dbms_output.put_line('Salaire annuel de l''employ� n� 3 : ' || pkg_exemple.SalaireAnnuel(3));
   dbms_output.put_line('Salaire annuel de l''employ� n� 8 : ' || pkg_exemple.SalaireAnnuel(8));
END;
