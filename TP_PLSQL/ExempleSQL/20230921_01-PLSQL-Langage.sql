/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01b-PLSQL-Ex.sql            Auteur : Ch. Stettler
Objet  : D�mo PL/SQL - Bloc anonyme - SELECT INTO - D�claration de variables
---------------------------------------------------------------------------- */

-- Ce bloc anonyme (non stock�) permet d'effectuer des tests (g�n�ralement appelera simplement une proc�dure stock�e, mais il peut y avoir du code comme ci-dessous)
-- on lancera ce bloc anonyme dans une SQL Window
DECLARE
   -- d�claration d'une variable contenant un attribut(un champ) de la table
   v_emp_nom    exe_employe.emp_nom%TYPE;   -- on r�cup�re le TYPE du champ emp_nom de la table exe_employe
   v_emp_prenom exe_employe.emp_prenom%TYPE;
   
   -- d�claration d'une variable contenant un enregistrement(une ligne) de la table (donc tous les champs)
   v_employe    exe_employe%ROWTYPE;   -- on sp�cifie le ROWTYPE de la table exe_employe
   
   -- d�claration de variables diverses
   v_nb      INTEGER;
BEGIN
   dbms_output.put_line('Bloc anonyme (non stock�) permettant d''effectuer des tests');
   dbms_output.put_line('Affichage d''un message dans la fen�tre (l''onglet) d''output');

   -- lecture dans la bdd : SELECT INTO une (ou plusieurs) variables
   SELECT emp_nom, emp_prenom INTO v_emp_nom, v_emp_prenom FROM exe_employe WHERE emp_no=1;
   dbms_output.put_line('Employ� : ' || v_emp_prenom || ' ' || v_emp_nom);

   -- lecture dans la bdd : SELECT * INTO : pour lire tous les champs d'un enregistrement (d'une seule ligne !)
   SELECT * INTO v_employe FROM exe_employe WHERE emp_no=1;
   dbms_output.put_line('Salaire : ' || v_employe.emp_salaire);

   SELECT COUNT(*) INTO v_nb FROM exe_employe;
   dbms_output.put_line('Nombre d''employ�s : ' || v_nb);
END;
/
SELECT * FROM exe_employe;
