CREATE OR REPLACE TRIGGER trg_affectation_bis
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vw_exa_projets
  FOR EACH ROW
DECLARE
  -----------------------------------------------------
  v_emp_no             exa_employe.emp_no%TYPE;
  v_emp_nom_prenom     exa_employe.emp_nom_prenom%TYPE;
  -----------------------------------------------------
  v_pro_no             exa_projet.pro_no%TYPE;
  v_pro_nom            exa_projet.pro_nom%TYPE;
  -----------------------------------------------------
  v_pro_priorite       exa_projet.pro_priorite%TYPE;
  v_pro_priorite_new   exa_projet.pro_priorite%TYPE;
  -----------------------------------------------------
  v_cat_nom            exa_categorie.cat_nom%TYPE;
  v_cat_no             exa_categorie.cat_no%TYPE;
  -----------------------------------------------------
  current_pro_no       INTEGER;
  -----------------------------------------------------
BEGIN

  BEGIN
    -------------------------------------------------------------------------------------------------------------------------------------------
    -- Check si l'employ� existe ==> RAISE_APPLICATION_ERROR
    -------------------------------------------------------------------------------------------------------------------------------------------
    SELECT emp_no, emp_nom_prenom INTO v_emp_no, v_emp_nom_prenom FROM exa_employe WHERE emp_nom_prenom = :NEW.employes;
    
    BEGIN
      -----------------------------------------------------------------------------------------------------------------------------------------
      -- Check si le projet existe
      -----------------------------------------------------------------------------------------------------------------------------------------
      SELECT pro_no, pro_nom INTO v_pro_no, v_pro_nom FROM exa_projet WHERE pro_nom = :NEW.projet;
    EXCEPTION
      WHEN no_data_found THEN  
        ---------------------------------------------------------------------------------------------------------------------------------------  
        -- Le projet n'existe pas et on INSERT
        ---------------------------------------------------------------------------------------------------------------------------------------
        IF inserting THEN        
          -------------------------------------------------------------------------------------------------------------------------------------
          BEGIN
            -- Check si la priorit� existe
            SELECT pro_priorite INTO v_pro_priorite FROM exa_projet WHERE pro_priorite = :NEW.priorite;
            -- La priorit� exite d�j�, il faut prendre la suivante
            SELECT MAX(pro_priorite)+1 INTO v_pro_priorite FROM exa_projet; 
            v_pro_priorite_new := v_pro_priorite;       
          EXCEPTION
            WHEN no_data_found THEN
              -- La priorit� n'existe pas, on peut la reprendre (m�me si elle est vide, car on peut inserer un projet sans attribut priorit�)
              v_pro_priorite_new := :NEW.priorite;
          END;
          -------------------------------------------------------------------------------------------------------------------------------------   
          BEGIN
            -- Check si la categorie existe
            SELECT cat_no, cat_nom INTO v_cat_no, v_cat_nom FROM exa_categorie WHERE cat_nom = :NEW.categorie;
          EXCEPTION
            -- La cat�gorie n'existe pas
            WHEN no_data_found THEN
              IF(:NEW.categorie IS NULL) THEN
                -- La cat�gorie n'est pas donn�, on lui attribu� la 1 (car quand on ins�re un projet, il doit avoir un num�ro de cat�gorie FK)
                v_cat_no := 1;
              ELSE
                -- La cat�gorie est donn�e, on ins�re cette nouvelle cat�gorie dans la BDD
                EXECUTE IMMEDIATE 'INSERT INTO exa_categorie VALUES (NULL, ''' || :NEW.categorie || ''')';
                dbms_output.put_line('La cat�gorie ' ||:NEW.categorie ||' n''existais pas. Elle vient d''�tre cr��');
                -- Et on r�cup�re le n� de cat�gorie
                SELECT cat_no INTO v_cat_no FROM exa_categorie WHERE cat_nom = :NEW.categorie;
              END IF;
          END;
          -------------------------------------------------------------------------------------------------------------------------------------
          -- On ins�re le nouveau projet avec :
          -------------------------------------------------------------------------------------------------------------------------------------
          ---- Le num�ro du projet = NULL => Sequence autoamtique
          ---- Le nom du projet
          ---- La descritpion peut �tre vide (lorsqu'elle n'est pas donn�e dans le INSERT
          ---- La priorit�
          ---- La cat�gorie
          -------------------------------------------------------------------------------------------------------------------------------------
          EXECUTE IMMEDIATE 'INSERT INTO exa_projet VALUES (NULL, ''' || :NEW.projet || ''', ''' || :NEW.description || ''', ''' || v_pro_priorite_new || ''', ''' || v_cat_no || ''')';
          dbms_output.put_line('Le projet ' ||:NEW.projet ||' n''existais pas. Il vient d''�tre cr��');
          current_pro_no := sq_exa_projet_no.CURRVAL;    
          SELECT pro_no, pro_nom INTO v_pro_no, v_pro_nom FROM exa_projet WHERE pro_no = current_pro_no;
          -------------------------------------------------------------------------------------------------------------------------------------
        END IF;
        ---------------------------------------------------------------------------------------------------------------------------------------
        -- Le projet n'existe pas et on UPDATE ==> RAISE_APPLICATION_ERROR
        ---------------------------------------------------------------------------------------------------------------------------------------
        IF updating THEN
          RAISE_APPLICATION_ERROR(-20000, 'Le projet ' || :NEW.projet|| ' n''existe pas !');
        END IF;  
    END;
    -------------------------------------------------------------------------------------------------------------------------------------------
    -- On cr�� la nouvelle affectation
    -------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO exa_affectation VALUES (v_pro_no, v_emp_no);
    dbms_output.put_line(v_emp_nom_prenom || ' a �t� affect� au projet "' || v_pro_nom);
  
    -------------------------------------------------------------------------------------------------------------------------------------------
    -- RAISE_APPLICATION_ERROR : L'employ� n'existe pas
    -------------------------------------------------------------------------------------------------------------------------------------------  
  EXCEPTION
    WHEN no_data_found THEN 
      RAISE_APPLICATION_ERROR(-20001, 'L''employe '|| :NEW.employes ||' n''existe pas !');
  END;
  
END;
/
