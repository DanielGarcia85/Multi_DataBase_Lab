CREATE OR REPLACE PACKAGE exa_projet_fonction IS

  FUNCTION oterEmployeDesProjetsDeCategorie (i_emp_no IN exa_employe.emp_no%TYPE, i_cat_nom IN exa_categorie.cat_nom%TYPE) RETURN VARCHAR2;

END exa_projet_fonction;
/
CREATE OR REPLACE PACKAGE BODY exa_projet_fonction  IS

  FUNCTION oterEmployeDesProjetsDeCategorie (i_emp_nom IN exa_employe.emp_nom_prenom%TYPE, i_cat_nom IN exa_categorie.cat_nom%TYPE) RETURN VARCHAR2 IS
    v_retour   VARCHAR2(200);
    v_cat_no   exa_categorie.cat_no%TYPE;
    v_emp_no   exa_employe.emp_no%TYPE;
    c_projet   SYS_REFCURSOR;
    r_projet   c_projet%TYPE;
    v_rqt_sql  VARCHAR2(200);

  BEGIN
    
    BEGIN
      SELECT cat_no INTO v_cat_no FROM exa_categorie WHERE cat_nom = i_cat_nom;
      SELECT emp_no INTO v_emp_no FROM exa_employe WHERE emp_nom_prenom = i_emp_nom;
      v_rqt_sql := 'SELECT * from exa_projet WHERE pro_cat_no = ' || v_cat_no;
      OPEN c_projet FOR v_rqt_sql;
      FETCH c_projet INTO r_projet;
      WHILE c_projet%FOUND LOOP
       
        EXECUTE IMMEDIATE 'DELETE exa_affectation WHERE aff_pro_no = ' || r_projet.pro_no || ' AND aff_emp_no = ' || v_emp_no; 
        
        FETCH c_projet INTO r_projet;
      END LOOP;
      CLOSE c_projet;
    EXCEPTION
      WHEN no_data_found THEN dbms_output.put_line('Catégorie ou employé n''existe pas');
    END;
    
    RETURN v_retour;
  END oterEmployeDesProjetsDeCategorie;
  
  
END exa_projet_fonction;
/
