/* -------------------------------------------------
 Script : 20230919_TP-1_Cinéma_DanielGarcia
 Auteur : Daniel Garcia
 Date   : 19.09.2023
 Object : Travail pratique N°1 - 62-31_BDD-PL/SQL 
------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';

---------------------------------------------
-- Partie 1 : Révision langage SQL LDD & LMD
---------------------------------------------

--1) Afficher la liste des prochains films (pas encore sortis) du même type que le film « Élémentaire »
SELECT fil_no, fil_titre, fil_annee, fil_duree, fil_sortie, fil_typ_no, fil_realis, fil_descr
FROM cin_film
WHERE fil_sortie > SYSDATE
AND fil_typ_no = (SELECT fil_typ_no FROM cin_film WHERE LOWER (fil_titre) = 'élémentaire')
ORDER BY fil_no;

--2) Combien y a-t-il de films de chaque type ?
SELECT typ_nom "Type", COUNT(*) "Nombre"
FROM cin_film
JOIN cin_type ON fil_typ_no = typ_no
GROUP BY typ_nom
ORDER BY "Nombre" DESC;

--3) Quels sont les genres qui concernent plusieurs « documentaires » ? (
SELECT gen_nom
FROM cin_genre
JOIN cin_estGenre ON gen_no = est_gen_no
JOIN cin_film ON fil_no = est_fil_no
JOIN cin_type ON fil_typ_no = typ_no
WHERE LOWER (typ_nom) = 'documentaire'
GROUP BY gen_nom
HAVING COUNT(gen_nom) > 1
ORDER BY gen_nom;

--4) Conservez pour chaque film la langue originale :
--   • tous les documentaires sont en VO français
--   • tous les films ayant le genre « Thriller » sont en anglais
ALTER TABLE cin_film DROP (fil_langue);
ALTER TABLE cin_film ADD (fil_langue VARCHAR2(20) CONSTRAINT ch_fil_langue CHECK (fil_langue IN ('Français', 'Anglais')));
UPDATE cin_film SET fil_langue = 'Français' WHERE fil_typ_no = (SELECT typ_no FROM cin_type WHERE typ_nom = 'Documentaire');
UPDATE cin_film SET fil_langue = 'Anglais' WHERE fil_no IN (SELECT est_fil_no FROM cin_estGenre JOIN cin_Genre ON est_gen_no = gen_no WHERE gen_nom = 'Thriller');
COMMIT;
SELECT fil_no "N°", fil_titre "Titre", fil_duree "Durée", typ_nom "Type", fil_realis "Réalisateur", fil_langue "Langue"
FROM cin_film
JOIN cin_type ON fil_typ_no = typ_no;

--4 bis) Variante => meilleure solution :
--       Créer une table supplémentaire pour les langues : cin_Langue
--       Rajouter dans la table cin_Film un attribue Foreign Key qui point sur cin_Langue
ALTER TABLE cin_film DROP (fil_lan_no);
DROP TABLE cin_langue;
CREATE TABLE cin_langue (
       lan_no           NUMBER(5) CONSTRAINT pk_cin_langue PRIMARY KEY,
       lan_nom          VARCHAR2(20)
);
INSERT INTO cin_langue VALUES (1,'Français');
INSERT INTO cin_langue VALUES (2,'Anglais');
COMMIT;
ALTER TABLE cin_film ADD (fil_lan_no NUMBER(5));
ALTER TABLE cin_film ADD CONSTRAINT fk_cin_langue_film FOREIGN KEY (fil_lan_no) REFERENCES cin_langue (lan_no);
-- ALTER TABLE cin_film ADD (fil_lan_no NUMBER(5) CONSTRAINT fk_cin_langue_film REFERENCES cin_langue (lan_no);
UPDATE cin_film SET fil_lan_no = '1' WHERE fil_typ_no = (SELECT typ_no FROM cin_type WHERE LOWER (typ_nom) = 'documentaire');
UPDATE cin_film SET fil_lan_no = '2' WHERE fil_no IN (SELECT est_fil_no FROM cin_estGenre JOIN cin_Genre ON est_gen_no = gen_no WHERE LOWER (gen_nom) = 'thriller');
COMMIT;
SELECT fil_no "N°", fil_titre "Titre", fil_duree "Durée", typ_nom "Type", fil_realis "Réalisateur", lan_nom "Langue"
FROM cin_film
JOIN cin_type ON fil_typ_no = typ_no
LEFT JOIN cin_langue ON fil_lan_no = lan_no;


-----------------------------
-- Partie 2 - Langage PL/SQL
-----------------------------

/
DECLARE
  v_cin_film         cin_film%ROWTYPE;
  v_typ_nom          cin_type.typ_nom%TYPE;
  v_nb_film          NUMBER(5);
BEGIN
  SELECT * INTO v_cin_film FROM cin_film WHERE fil_titre='Dogman';
  SELECT typ_nom INTO v_typ_nom FROM cin_type JOIN cin_film ON typ_no=fil_typ_no WHERE fil_titre='Dogman';
  SELECT COUNT(*) INTO v_nb_film FROM cin_film WHERE fil_sortie = (SELECT fil_sortie FROM cin_film WHERE fil_titre = 'Dogman');
  dbms_output.put_line (v_cin_film.fil_titre||' :');
  dbms_output.put_line ('- numéro       : '|| v_cin_film.fil_no);
  dbms_output.put_line ('- type         : '|| v_typ_nom);
  dbms_output.put_line ('- réalisateur  : '|| v_cin_film.fil_realis);
  dbms_output.put_line ('- durée        : '|| v_cin_film.fil_duree);
  dbms_output.put_line ('- '|| v_nb_film ||' films sortis le même jour ('|| v_cin_film.fil_sortie ||')');
END;


