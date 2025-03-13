/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 04-SubType-Record.sql       Auteur : Ch. Stettler
Objet  : Définition de SUBTYPE et de RECORD
---------------------------------------------------------------------------- */

-- Version 1) utilisation du type implicite du curseur (déclaration implicite de la variale dans la boucle FOR)
DECLARE
   CURSOR csr_employes IS SELECT emp_nom, emp_prenom, dep_nom FROM exe_employe LEFT JOIN exe_dept ON dep_no=emp_dep_no;
BEGIN
   FOR v_employe_et_dept IN csr_employes LOOP
      dbms_output.put_line(v_employe_et_dept.emp_nom || ': ' || v_employe_et_dept.dep_nom);
   END LOOP;
END;
/
-- Version 2) utilisation du type csr_employes%ROWTYPE pour déclarer la variable
DECLARE
   CURSOR csr_employes IS SELECT emp_nom, emp_prenom, dep_nom FROM exe_employe LEFT JOIN exe_dept ON dep_no=emp_dep_no;
   v_employe_et_dept csr_employes%ROWTYPE;   -- utilisation du type du curseur
BEGIN
   OPEN csr_employes;
   FETCH csr_employes INTO v_employe_et_dept;
   WHILE csr_employes%FOUND LOOP
      dbms_output.put_line(v_employe_et_dept.emp_nom || ': ' || v_employe_et_dept.dep_nom);
      FETCH csr_employes INTO v_employe_et_dept;
   END LOOP;
   CLOSE csr_employes;
END;
/
-- Version 3) création d'un nouveau type (SUBTYPE) basé sur le type du csr_employes
DECLARE
   CURSOR csr_employes IS SELECT emp_nom, emp_prenom, dep_nom FROM exe_employe LEFT JOIN exe_dept ON dep_no=emp_dep_no;
   SUBTYPE T_EMPLOYE_ET_DEPT IS csr_employes%ROWTYPE; -- création d'un subtype basé sur csr_employes%ROWTYPE; Et on pourrait rajouter des contraintres supplémentaires
   v_employe_et_dept T_EMPLOYE_ET_DEPT;
BEGIN
   NULL; -- idem version 2
END;
/
-- Version 4) un TYPE RECORD permet de spécifier les champs
DECLARE
   CURSOR csr_employes IS SELECT emp_nom, emp_prenom, dep_nom FROM exe_employe LEFT JOIN exe_dept ON dep_no=emp_dep_no;
   TYPE T_EMPLOYE_ET_DEPT IS RECORD (nom exe_employe.emp_nom%TYPE, prenom exe_employe.emp_prenom%TYPE, dept exe_dept.dep_nom%TYPE);
   v_employe_et_dept T_EMPLOYE_ET_DEPT;
BEGIN
   NULL; -- idem version 2
END;
/
-- Version 5) création d'un objet de schéma TYPE ==> CREATE OR REPLACE TYPE T_EMPLOYE_ET_DEPT IS OBJECT/TABLE/ARRAY
CREATE OR REPLACE TYPE T_EMPLOYE_ET_DEPT IS OBJECT (nom VARCHAR2(20), prenom VARCHAR2(20), dept VARCHAR2(20));
