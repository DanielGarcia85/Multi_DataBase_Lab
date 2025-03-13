create or replace package package_Exemple is

  PROCEDURE AfficherEmploye (i_emp_no IN exe_employe.emp_no%TYPE);
  FUNCTION NombreDEmployes RETURN INTEGER;

end package_Exemple;
/
create or replace package body package_Exemple IS

   -- Tout les code va être ici, dans le Package Body
   
   -- Par défaut, tout est private, donc visible uniquement ici
   
   v_exemple INTEGER; -- Variable globale, utilisable dans tout le package

   -- Une procédure effectue un traitement => son nom commence par un verbe qui indique ce qu'elle fait
   -- (En Java => si il y a void, c'est une procédure. Il n'y a pas de return)
   /*private*/
   PROCEDURE AfficherEmploye (i_emp_no IN exe_employe.emp_no%TYPE)IS
     v_employe exe_employe%ROWTYPE;
   BEGIN
     SELECT * INTO v_employe FROM exe_employe WHERE emp_no = i_emp_no;
       dbms_output.put_line('Affichage des données de l''employé ' ||i_emp_no||' : ' || v_employe.emp_prenom || ' ' || v_employe.emp_nom);
     EXCEPTION
      WHEN NO_DATA_FOUND THEN  dbms_output.put_line('L''employé n° ' ||i_emp_no|| ' n''existe pas !');
     END AfficherEmploye;
   
   -- Une fonction retourne une valeur => son nom indique ce qu'elle retourne
   -- (En Java => int / boolean / double / ... Chaque fois qu'on indique le type qu'on retourne)
   /*private*/
   FUNCTION NombreDEmployes RETURN INTEGER IS
     v_nb INTEGER;
   BEGIN
     SELECT COUNT (*) INTO v_nb FROM exe_employe;
     RETURN v_nb;
   END;
   
   
   BEGIN-- Ce bloc n'est exécuté que juste avant le 1er appel à qqch dans ce package
    -- C'est le bloc d'initialisation
    -- Il doit être à la fin, sans END
    dbms_output.put_line('Execution de package_Exemple');
 
end package_Exemple;
/
