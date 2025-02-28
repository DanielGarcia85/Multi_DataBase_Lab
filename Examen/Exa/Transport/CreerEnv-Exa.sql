/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - Exa-TransportsEntreAgences-CreerEnv.sql    Auteur : Ch. Stettler
Objet  : Création et remplissage des tables pour l'examen du 18/01/2023 - TransportsEntreAgences
---------------------------------------------------------------------------- */
DROP TABLE exa_colis;
DROP TABLE exa_transport;
DROP TABLE exa_agence;
DROP TABLE exa_log_agence_1;
DROP TABLE exa_log_agence_2;
DROP TABLE exa_log_agence_3;
DROP TABLE exa_log_agence_4;
DROP TABLE exa_log_agence_5;
DROP VIEW vw_exa_transports;
DROP SEQUENCE sq_exa_transport_no;

CREATE TABLE exa_agence (
   age_no          NUMBER(5)   CONSTRAINT pk_exa_agence PRIMARY KEY,
   age_nom         VARCHAR2(20),
   age_type        VARCHAR2(1) CONSTRAINT ch_age_type CHECK (age_type IN ('V','R','C')),
   age_horaire     VARCHAR2(20)
);

CREATE TABLE exa_transport (
   tra_no          NUMBER(5)   CONSTRAINT pk_exa_transport PRIMARY KEY,
   tra_poids_max   NUMBER(5),
   tra_statut      VARCHAR2(1),
   tra_age_depart  NUMBER(5)   CONSTRAINT fk_exa_agence_depart_trsp REFERENCES exa_agence(age_no),
   tra_age_arrivee NUMBER(5)   CONSTRAINT fk_exa_agence_arrivee_trsp REFERENCES exa_agence(age_no)
);

CREATE TABLE exa_colis (
   col_no          NUMBER(5)   CONSTRAINT pk_exa_colis PRIMARY KEY,
   col_poids       NUMBER(5),
   col_age_depart  NUMBER(5)   CONSTRAINT fk_exa_agence_depart_colis REFERENCES exa_agence(age_no),
   col_age_arrivee NUMBER(5)   CONSTRAINT fk_exa_agence_arrivee_colis REFERENCES exa_agence(age_no),
   col_tra_no      NUMBER(5)   CONSTRAINT fk_exa_transport_colis REFERENCES exa_transport(tra_no)
);

CREATE TABLE exa_log_agence_1 (msg VARCHAR2(100));
CREATE TABLE exa_log_agence_2 (msg VARCHAR2(100));
CREATE TABLE exa_log_agence_3 (msg VARCHAR2(100));
CREATE TABLE exa_log_agence_4 (msg VARCHAR2(100));
CREATE TABLE exa_log_agence_5 (msg VARCHAR2(100));

CREATE SEQUENCE sq_exa_transport_no;
CREATE OR REPLACE TRIGGER exa_NumeroNewTransport BEFORE INSERT ON exa_transport FOR EACH ROW BEGIN :NEW.tra_no:=sq_exa_transport_no.nextval; END;
/
CREATE OR REPLACE VIEW vw_exa_transports (NUMERO, STATUT, POIDS_MAX, DEPART, AGENCE_DEPART, ARRIVEE, AGENCE_ARRIVEE, NO_COLIS, POIDS_COLIS) AS 
   SELECT
     tra_no,
     tra_statut,
     tra_poids_max,
     tra_age_depart,
     'Point ' || CASE UPPER(dep.age_type)
       WHEN 'V' THEN 'de vente'
       WHEN 'R' THEN 'de retrait'
       WHEN 'C' THEN 'conseil' END || ' de ' || dep.age_nom,
     tra_age_arrivee,
     'Point ' || CASE UPPER(arr.age_type)
      WHEN 'V' THEN 'de vente'
       WHEN 'R' THEN 'de retrait'
       WHEN 'C' THEN 'conseil' END || ' de ' || arr.age_nom,
       col_no,
       col_poids
   FROM exa_transport
   LEFT JOIN exa_colis ON col_tra_no=tra_no
   JOIN exa_agence dep ON dep.age_no=tra_age_depart
   JOIN exa_agence arr ON arr.age_no=tra_age_arrivee
   ORDER BY tra_no;

INSERT INTO exa_agence VALUES (1, 'Carouge', 'V', '8h-14h');
INSERT INTO exa_agence VALUES (2, 'Bernex', 'R', '9h-12h');
INSERT INTO exa_agence VALUES (3, 'Corsier', 'R', '14h-18h');
INSERT INTO exa_agence VALUES (4, 'Meyrin', 'V', '8h-18h');
INSERT INTO exa_agence VALUES (5, 'Lancy', 'C', '8h-14h');
COMMIT;

INSERT INTO exa_transport VALUES (NULL, 50, 'T', 1, 3);
INSERT INTO exa_transport VALUES (NULL, 10, 'T', 3, 5);
INSERT INTO exa_transport VALUES (NULL, 25, 'P', 2, 1);
INSERT INTO exa_transport VALUES (NULL, 25, 'P', 1, 3);
INSERT INTO exa_transport VALUES (NULL, 50, 'P', 2, 4);
COMMIT;

INSERT INTO exa_colis VALUES (101, 10, 1, 3, 1);
INSERT INTO exa_colis VALUES (102, 15, 2, 4, NULL);
INSERT INTO exa_colis VALUES (103,  5, 1, 4, NULL);
INSERT INTO exa_colis VALUES (104, 25, 1, 3, 1);
INSERT INTO exa_colis VALUES (105, 12, 5, 4, NULL);
INSERT INTO exa_colis VALUES (106, 20, 1, 5, NULL);
INSERT INTO exa_colis VALUES (107, 15, 1, 3, NULL);
INSERT INTO exa_colis VALUES (108,  5, 2, 3, NULL);
INSERT INTO exa_colis VALUES (109, 10, 2, 4, NULL);
INSERT INTO exa_colis VALUES (110, 10, 1, 3, 4);
INSERT INTO exa_colis VALUES (111, 10, 2, 4, 5);
INSERT INTO exa_colis VALUES (112, 10, 2, 5, NULL);
INSERT INTO exa_colis VALUES (113, 20, 2, 4, 5);
INSERT INTO exa_colis VALUES (114, 50, 1, 3, NULL);
INSERT INTO exa_colis VALUES (115, 10, 1, 4, NULL);
INSERT INTO exa_colis VALUES (116, 20, 2, 3, NULL);
INSERT INTO exa_colis VALUES (117, 25, 5, 3, NULL);
INSERT INTO exa_colis VALUES (118, 15, 1, 4, NULL);
INSERT INTO exa_colis VALUES (119,  5, 1, 3, NULL);
INSERT INTO exa_colis VALUES (120, 25, 4, 3, NULL);
INSERT INTO exa_colis VALUES (121, 30, 1, 4, NULL);
COMMIT;
