/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 08-ExecuteImmediate.sql     Auteur : Ch. Stettler
Objet  : SQL dynamique  -  Instruction EXECUTE IMMEDIATE 
---------------------------------------------------------------------------- */

-- EXECUTE IMMEDIATE permet de lancer des rqt SQL dynamiques :

-- Lancer un SELECT COUNT sans connaître le nom de la table : (reçu en paramètre)
CREATE FUNCTION NbLignes (i_table IN VARCHAR2) RETURN INTEGER IS
   v_instr VARCHAR2(200);
   v_nb    INTEGER;
BEGIN
   v_instr := 'SELECT COUNT(*) FROM ' || i_table;
   EXECUTE IMMEDIATE v_instr INTO v_nb;
   RETURN v_nb;
END NbLignes;

/

-- Effectuer un INSERT dans une table indiquée en paramètre :
CREATE PROCEDURE insert_into_table ( i_table IN VARCHAR2, i_key IN INTEGER, i_value IN VARCHAR2) IS
   v_instr VARCHAR2(200);
BEGIN
   v_instr := 'INSERT INTO ' || i_table || ' VALUES (:cle, :valeur)';
   EXECUTE IMMEDIATE v_instr USING i_key, i_value;
END insert_into_table;

/

-- Lancer des instructions LDD : CREATE / ALTER / DROP :
CREATE PROCEDURE CreerSequenceEmploye IS
   v_nb NUMBER;
BEGIN
   SELECT MAX(emp_no)+1 INTO v_nb FROM exe_employe;
   EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_empl START WITH ' || v_nb;
END CreerSequenceEmploye;

/

-- Lancer des instructions LDD : ALTER pour désactiver/réactiver (temporairement) une contrainte d'intégrité :
BEGIN
   EXECUTE IMMEDIATE 'ALTER TABLE exe_employe DISABLE CONSTRAINT fk_exe_employe_dept'; 
	 -- chargement de masse de données, sans valider la contraite de FK, puis réactiver la contrainte :
   EXECUTE IMMEDIATE 'ALTER TABLE exe_employe ENABLE CONSTRAINT fk_exe_employe_dept'; 
END;

/

-- Choisir dynamiquement le nom de la procédure à appeler :
DECLARE
   v_nom_proc VARCHAR2(50) := 'xyz';
BEGIN
   EXECUTE IMMEDIATE 'BEGIN ' || v_nom_proc || '(); END;';
END;

/

-- Utilisation de 'bind_argument' (ou 'bind_variable') avec la clause USING :
-- utilisable uniquement pour remplacer des valeurs (et non pas un nom de table, de procédure, ... ==> dans ces cas: concaténer)
DECLARE
   v_instr    VARCHAR2(200);
   v_nom_proc VARCHAR2(20) := 'xx';
   v_valeur1  NUMBER;
   v_valeur2  NUMBER;
BEGIN
   v_instr := 'BEGIN ' || v_nom_proc || '(:param1, :param2); END;';
   EXECUTE IMMEDIATE v_instr USING v_valeur1, v_valeur2;
END;
/