CREATE OR REPLACE TRIGGER trg_affectation
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vw_exa_projets
  FOR EACH ROW
DECLARE
  v_pro_no          exa_projet.pro_no%TYPE;
  v_emp_no          exa_employe.emp_no%TYPE;
  v_cat_nom         exa_categorie.cat_nom%TYPE;
  v_cat_no          exa_categorie.cat_no%TYPE;
BEGIN
  BEGIN
    SELECT cat_nom INTO v_cat_nom FROM exa_categorie WHERE cat_nom = :NEW.categorie;
  EXCEPTION
    WHEN no_data_found THEN
      EXECUTE IMMEDIATE 'INSERT INTO exa_categorie VALUES (NULL, ' || :NEW.categorie || ')';
  END;
  SELECT cat_no INTO v_cat_no FROM exa_categorie WHERE cat_nom = :NEW.categorie;
  IF inserting THEN
    BEGIN
      SELECT pro_no INTO v_pro_no FROM exa_projet WHERE pro_nom = :NEW.projet;
    EXCEPTION
      WHEN no_data_found THEN 
        dbms_output.put_line('Le projet ' ||:NEW.projet ||' n''existais pas. Il vient d''être créé');
        EXECUTE IMMEDIATE 'INSERT INTO exa_projet VALUES (NULL, ' || :NEW.projet || ', ' || :NEW.description || ', ' || :NEW.priorite|| ', ' || v_cat_no || ')';
    END;
  END IF;
  
  IF updating THEN
    BEGIN
      SELECT pro_no INTO v_pro_no FROM exa_projet WHERE pro_nom = :NEW.projet;
    EXCEPTION
      WHEN no_data_found THEN 
       RAISE_APPLICATION_ERROR(-20000, 'Le projet ' || :NEW.projet|| ' n''existe pas !');
    END;
  END IF;
  
  BEGIN
   SELECT emp_no INTO v_emp_no FROM exa_employe WHERE emp_nom_prenom = :NEW.employes;
   INSERT INTO exa_affectation VALUES (v_pro_no, v_emp_no);
  EXCEPTION
    WHEN no_data_found THEN 
      RAISE_APPLICATION_ERROR(-20001, 'L''employe '|| :NEW.employes ||' n''existe pas !');
  END;
  
END;
/
