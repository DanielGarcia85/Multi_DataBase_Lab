-- un SELECT INTO ne retourne qu'un seul et un seul enregistrement (dans un bloc PLSQL)
--   Si aucun     =>  EXECPTION NO_DATA_FOUND
--   SI plusieurs =>  EXCEPTION TOO_MANY_ROWS

SELECT emp_prenom FROM exe_employe WHERE LOWER(emp_nom) = 'terieur';

-- Comment faire si on veut la liste de tous les employ�s => CURSEUR
-- Aussit�t qu'on veut/pense r�cup�rer plusierus enregistrements => et qu'on veut les r�cup�rer

DECLARE
  -- 1) D�claration du CURSOR
  CURSOR crs_employes(numeroDuDepartement exe_dept.dep_no%TYPE) IS SELECT * FROM exe_employe WHERE emp_dep_no = numeroDuDepartement ORDER BY emp_nom;
  v_employe exe_employe%ROWTYPE; -- Ici on d�clare le v_employe qui se trouve dans le WHILE (dans le FOR pas besoin, car d�claration implicite)
BEGIN
  -- 2) Ouvrir le curseur, c'est � dire lancer le SELECT
  -- Si on souhaite parcourir tous les enregsitrements r�cup�r�s du curseur, sans traitement particuluier des enregsitrements
  -- Dans le cas o� on veut faire un un FOR EACH
  FOR v_employe IN crs_employes(3) LOOP -- (v_employe est d�clar� implicitement dans le FOR)
    -- Le FOR ouvre le curseur, c'est � dire lancer le SELECT
    dbms_output.put_line(v_employe.emp_prenom || ' ' ||v_employe.emp_nom);
  END LOOP;
  -- Avantage du curseur => ne d�clenche pas d'exception :
  -- Si il y a 0 enreg => fait 0x la boucle
  -- Si il y a 1 enreg => fait 1x la boucle
  -- Si il y a 10 enreg => fait 10x la boucle
   
  -- Version 2 : Possibilit� de param�trer les curseurs => On indique le param�tre dans la d�claration, on l'utilise dans le SELECT
  -- Et on fournit une valeur dans � l'ouvertur du curseur, c�d dans le FOR
  
  -- Si on souhaite faire un traitement particulier du 1er enregistrement, ou du dernier,
  -- ou en traiter 1 sur 2, ou s'arr�ter avant la fin,...
  -- donc dans tous les cas o� ne fait pas un traitement exhaustif => Boucle WHILE
  
  -- Avec le FOR le curseur est ouvert et ferm� tout seul
  -- Avec le WHILE, on doit nous m�me ouvrir et fermer le curseur
  
  OPEN crs_employes(3);  -- C'est ici que le SELECT est lanc�
  FETCH crs_employes INTO v_employe; -- Ce FETCH r�cup�re le 1er enregistrement et le stock dnas une variable v_employe
  WHILE crs_employes%FOUND AND v_employe.emp_salaire < 6000 LOOP
    dbms_output.put_line(v_employe.emp_prenom || ' ' ||v_employe.emp_nom);
    FETCH crs_employes INTO v_employe; -- Ce FETCH r�cup�re le prochain enregsitrement
  END LOOP;
  
  CLOSE crs_employes;
  
END;
