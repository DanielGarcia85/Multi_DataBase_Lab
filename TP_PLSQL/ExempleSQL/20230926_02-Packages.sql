/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 02-Packages-Exemple.sql     Auteur : Ch. Stettler
Objet  : Exemple d'utilisation des packages PL/SQL
---------------------------------------------------------------------------- */

-- Ce package contient les définitions visibles de l'extérieur
CREATE OR REPLACE PACKAGE pkg_employe IS
  PROCEDURE affiEmploye (i_emp_no  IN exe_employe.emp_no%TYPE);
  PROCEDURE affiEmploye (i_emp_nom IN exe_employe.emp_nom%TYPE);
  var_publique  NUMBER; -- visible dans ce package et À L'EXTERIEUR du package
  nbreDEmployes NUMBER;
END pkg_employe;
/
-- Le package body contient le code des procédures
CREATE OR REPLACE PACKAGE BODY pkg_employe IS
  v_globale  NUMBER;      -- peut être utilisée DANS toutes les proc du package

  PROCEDURE Initialisation IS
  BEGIN
    dbms_output.put_line('Dans la proc d''Initialisation.');
    SELECT COUNT(*) INTO nbreDEmployes FROM exe_employe;
  END;

  PROCEDURE affiEmploye (i_emp_no IN exe_employe.emp_no%TYPE) IS
    v_employe  exe_employe%ROWTYPE;
    v_locale   NUMBER;
  BEGIN
    v_locale := 123;    -- ne peut être utilisée que dans cette procédure
    SELECT * INTO v_employe FROM exe_employe WHERE emp_no = i_emp_no;
    dbms_output.put_line(v_employe.emp_prenom || ' ' || v_employe.emp_nom);
  END affiEmploye;

  PROCEDURE affiEmploye (i_emp_nom IN exe_employe.emp_nom%TYPE) IS
    v_employe  exe_employe%ROWTYPE;
  BEGIN
    SELECT * INTO v_employe FROM exe_employe WHERE UPPER(emp_nom) = UPPER(i_emp_nom);
    dbms_output.put_line(v_employe.emp_prenom || ' ' || v_employe.emp_nom);
  END affiEmploye;

  PROCEDURE procLocale IS -- procédure non visible hors du package
  BEGIN
    NULL;
  END procLocale;

BEGIN
  Initialisation;
END pkg_employe;
/

-- Le code ci-dessous permet de tester les composants du package.
-- Il est généralement situé dans un autre programme / autre fichier / autre langage !
DECLARE
  nb NUMBER;
BEGIN 
  pkg_employe.affiEmploye(3);
  pkg_employe.affiEmploye(4);
  pkg_employe.affiEmploye('Bon');
  dbms_output.put_line('nombre = ' || pkg_employe.nbreDEmployes);
END;
