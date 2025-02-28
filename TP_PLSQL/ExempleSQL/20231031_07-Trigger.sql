
CREATE TABLE exe_employe (
  emp_no      NUMBER(5) CONSTRAINT PRIMARY KEY
  emp_nom     VARCHAR2(20)
  emp_salaire NUMBER(9,2) CONSTRAINT CHECK (emp_salaire > 1000)
);

/

CREATE TRIGGER trg_update_employe
       -- condition de d�clenchement => la seule diff�rence avec une proc�dure/package/fonction
       -- 1) sur quelle table ? LMD se base sur une table. On va faire que pour du LMD dans le cours
       -- 2) sur quel �n�vement (INSERT/UPDATE/DELETE) ?
       -- 3) avant ou apr�s la maj (BEFORE/AFTER)? => privil�giez l'AFTER
       BEFORE INSERT ON exe_employe
       -- ou/et
       AFTER UPDATE ON exe_employe
       AFTER UPDATE OF emp_salaire ON exe_employe -- ici on peut lui dire de d�clencher seulement si un attribue a �t� modifi�
       
       WHEN (NEW.emp_no IS NULL)
       
       --BEFORE - Si on souhaite modifier les valeurs (INSERT OR UPDATE)
       --       - Si on veut bloquer l'instruction RAISE_APPLICATION_ERROR
       
       --AFTER  - Si on souhaite faire du log (en g�n�ral c'est �a)
       
       
       -- 4) combien de fois d�clencher le triger si il touche plusieurs enregistrements
       --    => 1 seule fois ou 1 fois par enregsitrement
       FOR EACH STATEMENT -- une seule fois pour l'ensemble des enregistrement : implicite (si on met rien)
       FOR EACH ROW -- pour chaque enregistrement modifi�

--DECLARE
  --:NEW exe_employe%ROWTYPE;
  --:OLD exe_employe%ROWTYPE;

BEGIN
       -- code PL/SQL standard
       dbms_output.put_line('Un utilisateur a modifi� l''employ�' || :OLD.emp_nom || ' le ' || SYSDATE);
       raise_application_error(); -- pour retourner � Java l'information de ce qu'on a fait avec le trigger  
       
       IF INSERTING THEN ... END IF;
       IF UPDATING THEN ... END IF;
       IF DELETING THEN ... END IF;
           
END;

-- TABLE EN MUTATION
-- !!! Ne pas faire de select dans un triger BEFORE for each row (mais pour for each statement �a passe) !!!
/

UPDATE exe_employe SET emp_salaire=333 WHERE emp_dep_no=3;
