SELECT *
  FROM cin_film
  WHERE fil_sortie > SYSDATE
  AND fil_typ_no = (SELECT fil_typ_no FROM cin_film WHERE LOWER(fil_titre) = 'élémentaire');
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT typ_nom AS "Type", COUNT(fil_no) AS "Nombre"
  FROM cin_type JOIN cin_film ON typ_no = fil_typ_no
  GROUP BY typ_nom
  ORDER BY COUNT(fil_no) DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT gen_nom, typ_nom
  FROM cin_genre
  JOIN cin_estgenre ON gen_no=est_gen_no
  JOIN cin_film ON est_fil_no=fil_no
  JOIN cin_type ON fil_typ_no=typ_no
  WHERE LOWER(typ_nom) = 'documentaire'
  GROUP BY gen_nom, typ_nom
  HAVING COUNT(gen_nom)>=2
  ORDER BY gen_nom;
------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE cin_film DROP COLUMN fil_lan_no;
DROP TABLE cin_langue;
CREATE TABLE cin_langue (
  lan_no NUMBER(2) CONSTRAINT pk_cin_langue PRIMARY KEY,
  lan_nom VARCHAR2(50)
);
INSERT INTO cin_langue VALUES (1, 'Français');
INSERT INTO cin_langue VALUES (2, 'Anglais');
COMMIT;
ALTER TABLE cin_film ADD fil_lan_no NUMBER(2) CONSTRAINT fk_cin_langue_film REFERENCES cin_langue(lan_no);
UPDATE cin_film SET fil_lan_no=1 WHERE fil_typ_no=(SELECT typ_no FROM cin_type WHERE LOWER(typ_nom)= 'documentaire');
UPDATE cin_film SET fil_lan_no=2 WHERE fil_no IN (SELECT est_fil_no FROM cin_estgenre JOIN cin_genre ON est_gen_no=gen_no WHERE LOWER(gen_nom)='thriller');
COMMIT;
SELECT * FROM cin_film;
SELECT fil_no AS "N°", fil_titre AS "Titres", fil_duree AS "Durée", typ_nom AS "Type", fil_realis AS "Réalisateur", lan_nom AS "Langue" FROM cin_film JOIN cin_type ON fil_typ_no = typ_no JOIN cin_langue ON fil_lan_no = lan_no WHERE fil_lan_no IS NOT NULL;
------------------------------------------------------------------------------------------------------------------------------------------------------------
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
DECLARE
  v_cin_film cin_film%ROWTYPE;
  v_cin_type cin_type%ROWTYPE;
  v_nb_film_m_jour NUMBER(5);
BEGIN
  SELECT * INTO v_cin_film FROM cin_film WHERE LOWER(fil_titre) = 'dogman';
  dbms_output.put_line(v_cin_film.fil_titre|| ' :');
  dbms_output.put_line('- numéro       : ' || v_cin_film.fil_no);
  SELECT * INTO v_cin_type FROM cin_type WHERE typ_no=v_cin_film.fil_typ_no;
  dbms_output.put_line('- type         : ' || v_cin_type.typ_nom);
  dbms_output.put_line('- réalisateur  : ' || v_cin_film.fil_realis);
  dbms_output.put_line('- durée        : ' || v_cin_film.fil_duree);
  SELECT COUNT(fil_no) INTO v_nb_film_m_jour FROM cin_film WHERE fil_sortie = v_cin_film.fil_sortie GROUP BY fil_sortie;
  dbms_output.put_line('- ' || v_nb_film_m_jour || ' films sortis le même jour ' || v_cin_film.fil_sortie);
END;
/










