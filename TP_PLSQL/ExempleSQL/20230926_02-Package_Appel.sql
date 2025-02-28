BEGIN
  -- Les procédures ont les lance
  package_Exemple.AfficherEmploye(1);
  package_Exemple.AfficherEmploye(2);
  package_Exemple.AfficherEmploye(3);
  package_Exemple.AfficherEmploye(999);
  
  -- Les fonctions il faut les traiter, traiter leur valeur de retour
  
  -- a) On affiche directement la valeur retournée
  dbms_output.put_line('Valeur retournée : ' || package_Exemple.NombreDEmployes());
  
  -- b) On peut stocker la valeur de router
  DECLARE
     valeurDeRetour INTEGER;
  BEGIN
    valeurDeRetour := package_Exemple.nombreDEmployes();
    dbms_output.put_line(valeurDeRetour);
  END;
  
  -- c) On peut mettre la fonction dans une condition
  IF package_exemple.NombreDEmployes() > 10 THEN
    dbms_output.put_line('Beaucoup d''employées...');
  END IF;
  
END;
