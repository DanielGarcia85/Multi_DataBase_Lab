CREATE OR REPLACE TRIGGER trg_affectation
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vw_exa_projets
  FOR EACH ROW
DECLARE
  v_pro_no          exa_projet.pro_no%TYPE;
  v_emp_no          exa_employe.emp_no%TYPE;
  v_cat_nom         exa_categorie.cat_nom%TYPE;
  v_cat_no          exa_categorie.cat_no%TYPE;
 
 -- BEGIN
 --   SELECT cat_nom INTO v_cat_nom FROM exa_categorie WHERE cat_nom = :NEW.categorie;
 -- EXCEPTION
 --   WHEN no_data_found THEN
 --     EXECUTE IMMEDIATE 'INSERT INTO exa_categorie VALUES (NULL, ''' || :NEW.categorie || ''')';
  --END;
  
  --SELECT cat_no INTO v_cat_no FROM exa_categorie WHERE cat_nom = :NEW.categorie;

BEGIN
  SELECT emp_no INTO v_emp_no FROM exa_employe WHERE emp_nom_prenom = :NEW.employes;
   
  BEGIN
    SELECT pro_no INTO v_pro_no FROM exa_projet WHERE pro_nom = :NEW.projet;
    
    INSERT INTO exa_affectation VALUES (v_pro_no, v_emp_no);
    dbms_output.put_line('L''employé N°' || v_emp_no ||' vient d''être affecté au projet N° ' || v_pro_no);
      
  EXCEPTION
    WHEN no_data_found THEN 
      IF inserting THEN
        dbms_output.put_line('INSERT INTO exa_projet VALUES (''EXA'', ''Examen'', ''BDD'', 1, ''Dubois Dan'')');
        EXECUTE IMMEDIATE 'INSERT INTO exa_projet VALUES (NULL, ''EXA'', ''Examen'', ''BDD'', 1, ''Dubois Dan'')';  
        dbms_output.put_line('Le projet ' ||:NEW.projet ||' n''existais pas. Le projet EXA vient d''être créé');
        
        INSERT INTO exa_affectation VALUES (v_pro_no, v_emp_no);
        dbms_output.put_line('L''employé N°' || v_emp_no ||' vient d''être affecté au projet N° ' || v_pro_no);
      END IF;
      
      IF updating THEN
        RAISE_APPLICATION_ERROR(-20000, 'Le projet ' || :NEW.projet|| ' n''existe pas !');
      END IF;
             
  END;
   
EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20001, 'L''employe '|| :NEW.employes ||' n''existe pas !');
END;
/
