BEGIN
  nomDuPackage.nomDeLaProcedure();
END
-- 2 types de bloc de code PL/SQL => des blocs nommées et des blocs anonymes
-- Bloc nommées
CREATE PROCEDURE NomDeLaProcedure IS
BEGIN
  
END;
-- Bloc anonymes
BEGIN

END;
/ -- Un slash en colonne 1 permet de séparer les blocs

DECLARE
  -- Ceci est une variable
  v_emp_nom       exe_employe.emp_nom%TYPE;
  v_emp_prenom    exe_employe.emp_prenom%TYPE;
  v_employe       exe_employe%ROWTYPE; -- Toutes les colonnes de la table exe_employe, Pour récuperer tous les attribué d'une table, Fonctionne pour une seul table
                                       -- Par contre on peut pas utiliser le rowtype dans des jointure, il faut utiliser plusieurs select...
BEGIN
  -- En Java => System.out.println("test affiché dans le log...")
  -- En PL/SQL => dbms_output.put_lin('text qui sera affiché dans l'onglet Output')
  dbms_output.put_line('Test d''affichage');
  dbms_output.put('Test d''affichage'); -- Sur la même ligne
  dbms_output.put_line('Test d''affichage' ¦¦ 'suite du test'); -- double bar droite pour concatener
  
  INSERT INTO cin_typ VALUES(55, 'Nouveau type'); -- ça on peut faire
  
  -- pour faire un select il faut un INTO avec pour stocker ! attention faire un select qui ramène qu'un seul enregistrement pour qu'il rentre dans la variable
  SELECT  emp_nom INTO v_emp_nom FROM exe_employe WHERE emp_no=1;
  -- les noms des variables doivent être déclarer, nommé et type
  dbms_output.put_line('Nom de l''employé : ' ¦¦ v_emp_nom);
  
  SELECT emp_nom, emp_prenom INTO v_emp_nom, v_emp_prenom FROM exe_employe WHERE emp_no=1;
  
  SELECT * INTO v_employe FROM exe_employe WHERE emp_no=1; -- Avant cette ligne il n'y a rien encore dans v_employe
  dbms_output.put_line('Nom de l''employé : ' ¦¦ v_employe.emp_prenom ¦¦ ' ' ¦¦ v_employe.emp_nom);
  dbms_output.put_line('Salaire de : ' ¦¦ v_employe.emp_salaire);
  
END;




