/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 04-CurseurDynamique.sql     Auteur : Ch. Stettler
Objet  : Exemple d'utilisation de curseur dynamique
---------------------------------------------------------------------------- */

-- 1) curseur statique : le curseur est défini à la compilation, aucune variation possible
DECLARE
   CURSOR csr_emp IS SELECT * FROM exe_employe;
BEGIN
   FOR v_emp IN csr_emp LOOP   -- le FOR ouvre le curseur (exécute le SELECT)  /  parcourt le curseur automatiquement (FETCH)  /  puis le referme
      dbms_output.put_line(v_emp.emp_no || ': ' || v_emp.emp_prenom || ' ' || v_emp.emp_nom || ' gagne Frs ' || v_emp.emp_salaire || '.-');
   END LOOP;
END;

/

-- 2) curseur paramétré: on peut choisir/calculer une valeur (par ex. de salaire à partir de...) au moment de l'exécution
DECLARE
   CURSOR csr_emp(aPartirDe exe_employe.emp_salaire%TYPE) IS SELECT * FROM exe_employe WHERE emp_salaire >= aPartirDe;
   v_sal_moyen exe_employe.emp_salaire%TYPE;
BEGIN
   SELECT AVG(emp_salaire) INTO v_sal_moyen FROM exe_employe;
   FOR v_emp IN csr_emp(v_sal_moyen) LOOP   -- le FOR ouvre le curseur (donc exécute le SELECT) avec la valeur du paramètre fournie (le salaire moyen)
      dbms_output.put_line(v_emp.emp_no || ': ' || v_emp.emp_prenom || ' ' || v_emp.emp_nom || ' gagne Frs ' || v_emp.emp_salaire || '.-');
   END LOOP;
END;

/

-- 3) curseur dynamique: on peut définir entièrement la requête lors de l'exécution
DECLARE
   csr_emp     SYS_REFCURSOR;                       -- déclaration d'un curseur dynamique
   v_rqtSql    VARCHAR2(200);                       -- texte libre qui contiendra la requête à exécuter
   v_emp       exe_employe%ROWTYPE;                 -- boucle de parcours WHILE, donc déclaration de la variable
   v_sal_moyen exe_employe.emp_salaire%TYPE;
BEGIN
   v_rqtSql := 'SELECT * FROM exe_employe';         -- base de la requête à exécuter
   -- IF onNeVeutQueLesGrandsSalaires THEN          -- possibilité de rajouter des conditions
      SELECT AVG(emp_salaire) INTO v_sal_moyen FROM exe_employe;
      v_rqtSql := v_rqtSql || ' WHERE emp_salaire >= ' || v_sal_moyen; -- on complète la requête
   -- END IF;

   -- IF onVeutLesTrier THEN                        -- on peut rajouter des ORDER BY
      v_rqtSql := v_rqtSql || ' ORDER BY emp_nom';  -- on complète la requête
   -- END IF;

   OPEN csr_emp FOR v_rqtSql;   -- on indique ici la requête à exécuter, qui est fabriquées entièrement dynamiquement
   FETCH csr_emp INTO v_emp;    -- et on fait une boucle standard de parcours
   WHILE csr_emp%FOUND LOOP
      dbms_output.put_line(v_emp.emp_no || ': ' || v_emp.emp_prenom || ' ' || v_emp.emp_nom || ' gagne Frs ' || v_emp.emp_salaire || '.-');
      FETCH csr_emp INTO v_emp;
   END LOOP;
   CLOSE csr_emp;
END;
