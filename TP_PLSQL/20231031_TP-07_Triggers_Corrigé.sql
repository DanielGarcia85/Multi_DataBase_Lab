/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 07-Triggers-TP.sql          Auteur : Ch. Stettler
Objet  : TP Cinéma - Création de Trigger
---------------------------------------------------------------------------- */

-- 1) Créer un trigger « trg_Insert_Type » qui génère automatiquement la clé primaire des types de films.
--    Il faut que la séquence soit déjà créée, par exemple :
DROP   SEQUENCE sq_cin_type;
CREATE SEQUENCE sq_cin_type START WITH 4;
/
CREATE OR REPLACE TRIGGER trg_Insert_Type
   BEFORE INSERT ON cin_type
   FOR EACH ROW
BEGIN
   :NEW.typ_no := sq_cin_type.NEXTVAL;
END;
/

SELECT * FROM cin_type;
INSERT INTO cin_type (typ_nom) VALUES ('Court-métrage');
SELECT * FROM cin_type;
ROLLBACK;


-- 2) Créer un trigger « trg_Changement_Type » qui inscrit dans le log (dbms_output) un message lorsqu’un film change de type :

CREATE OR REPLACE TRIGGER trg_Changement_Type
   AFTER UPDATE OF fil_typ_no ON cin_film
   FOR EACH ROW
DECLARE
   v_typ_nom_old     cin_type.typ_nom%TYPE;
   v_typ_nom_new     cin_type.typ_nom%TYPE;
BEGIN
   BEGIN
      SELECT typ_nom INTO v_typ_nom_old FROM cin_type WHERE typ_no = :OLD.fil_typ_no;
   EXCEPTION
      WHEN no_data_found THEN NULL;
   END;
   BEGIN
      SELECT typ_nom INTO v_typ_nom_new FROM cin_type WHERE typ_no = :NEW.fil_typ_no;
   EXCEPTION
      WHEN no_data_found THEN NULL;
   END;

   dbms_output.put_line('Le film « ' || :OLD.fil_titre || ' » a changé de type :');
   dbms_output.put_line('**************************************');
   dbms_output.put_line('     Ancien type  : ' || v_typ_nom_old);
   dbms_output.put_line('     Nouveau type : ' || v_typ_nom_new);
   dbms_output.new_line;
END;
/

SELECT * FROM cin_film LEFT JOIN cin_type ON typ_no=fil_typ_no WHERE fil_no<5;
-- On modifie le type du film n° 2 en indiquant qu’il s’agit dorénavant d’un documentaire (type n° 2) :
UPDATE cin_film SET fil_typ_no = 2 WHERE fil_no = 2;
-- Rien ne doit s'afficher dans le log si on modifie la durée du film n° 2 :
UPDATE cin_film SET fil_duree = '3h' WHERE fil_no = 2;
-- Indiquez que le type du film n° 2 est dorénavant indéfini (inconnu, donc null).
UPDATE cin_film SET fil_typ_no = NULL WHERE fil_no = 2;
SELECT * FROM cin_film LEFT JOIN cin_type ON typ_no=fil_typ_no WHERE fil_no<5;
ROLLBACK;


-- 3) Créez un trigger « trg_Update_Type » qui, lors de la modification du nom d’un type, inscrit dans le log le nombre et la liste des films qui sont impactés (qui ont changé de type) :

CREATE OR REPLACE TRIGGER trg_Update_Type
   AFTER UPDATE ON cin_type
   FOR EACH ROW
DECLARE
   v_nb INTEGER;
BEGIN
   SELECT COUNT(*) INTO v_nb FROM cin_film WHERE fil_typ_no = :OLD.typ_no;
   dbms_output.put_line('Ces ' || v_nb || ' films ont changé de type (de ' || :OLD.typ_nom || ' à ' || :NEW.typ_nom || ') :');
   FOR v_film IN (SELECT * FROM cin_film WHERE fil_typ_no=:OLD.typ_no) LOOP
      dbms_output.put_line(' - ' || v_film.fil_titre || ' (' || v_film.fil_annee || ')');
   END LOOP;
END;
/

UPDATE cin_type SET typ_nom='Docu' WHERE typ_no=2;
ROLLBACK;
