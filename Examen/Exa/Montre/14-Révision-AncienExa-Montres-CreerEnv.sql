/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - Exa-Montres-CreerEnv.sql    Auteur : Ch. Stettler
Objet  : Création et remplissage des tables pour l'examen du 19/01/2022
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';

DROP TABLE exa_vente;
DROP TABLE exa_livraison;
DROP TABLE exa_montre;
DROP VIEW vw_exa_livraison;
DROP SEQUENCE sq_exa_vente_no;

CREATE TABLE exa_montre (
   mon_no         NUMBER(5)    CONSTRAINT pk_exa_montre PRIMARY KEY,
   mon_marque     VARCHAR2(20),
   mon_modele     VARCHAR2(20),
   mon_stock      NUMBER(5),
   mon_prix       NUMBER(5)
);

CREATE TABLE exa_livraison (
   liv_date       DATE,
   liv_mon_no     NUMBER(5)    CONSTRAINT fk_exa_livraison_montre REFERENCES exa_montre(mon_no),
   liv_nombre     NUMBER(3),
   CONSTRAINT pk_exa_livraison PRIMARY KEY (liv_date, liv_mon_no)
);

CREATE TABLE exa_vente (
   ven_no         NUMBER(5)    CONSTRAINT pk_exa_vente PRIMARY KEY,
   ven_mon_no     NUMBER(5)    CONSTRAINT fk_exa_vente_montre REFERENCES exa_montre(mon_no),
   ven_date       DATE,
   ven_ref_client VARCHAR2(4),
   ven_prix_vente NUMBER(5)
);

CREATE OR REPLACE VIEW vw_exa_livraison ("Date", "Marque", "Modele", "Nombre") AS 
   SELECT liv_date, mon_marque, mon_modele, liv_nombre FROM exa_livraison JOIN exa_montre ON mon_no=liv_mon_no;
CREATE SEQUENCE sq_exa_vente_no START WITH 17;

INSERT INTO exa_montre VALUES (1, 'Rolex', 'Daytona', 3, 178);
INSERT INTO exa_montre VALUES (2, 'Cartier', 'Secret', 1, 150);
INSERT INTO exa_montre VALUES (3, 'Piaget', 'Emperador', 3, 830);
INSERT INTO exa_montre VALUES (4, 'Patek Philippe', 'Supercomplication', 3, 940);
INSERT INTO exa_montre VALUES (5, 'cartier', 'Rotonde', 1, 68);
INSERT INTO exa_montre VALUES (6, 'CARTIER', 'Panthère', 1, 45);
INSERT INTO exa_montre VALUES (7, 'Breguet', '4111', 1, 770);
INSERT INTO exa_montre VALUES (8, 'Piaget', 'Limelight', 0, 850);
INSERT INTO exa_montre VALUES (9, 'Cartier', 'BallonBlanc', 1, 37);
COMMIT;

INSERT INTO exa_livraison VALUES('03.01.2022', 1, 3);
INSERT INTO exa_livraison VALUES('03.01.2022', 2, 1);
INSERT INTO exa_livraison VALUES('03.01.2022', 8, 1);
INSERT INTO exa_livraison VALUES('10.01.2022', 4, 1);
INSERT INTO exa_livraison VALUES('10.01.2022', 5, 1);
INSERT INTO exa_livraison VALUES('17.01.2022', 1, 5);
INSERT INTO exa_livraison VALUES('17.01.2022', 2, 1);
INSERT INTO exa_livraison VALUES('17.01.2022', 3, 2);
INSERT INTO exa_livraison VALUES('17.01.2022', 9, 1);
COMMIT;

INSERT INTO exa_vente VALUES(1,  2, '04.01.2022', 'EMus', 100);
INSERT INTO exa_vente VALUES(2,  1, '04.01.2022', 'JBez', 150);
INSERT INTO exa_vente VALUES(3,  9, '06.01.2022', 'BGat',  30);
INSERT INTO exa_vente VALUES(4,  1, '07.01.2022', 'BArn', 145);
INSERT INTO exa_vente VALUES(5,  5, '10.01.2022', 'MZuc',  60);
INSERT INTO exa_vente VALUES(6,  4, '10.01.2022', 'WBuf', 850);
INSERT INTO exa_vente VALUES(7,  8, '10.01.2022', 'LPag', 850);
INSERT INTO exa_vente VALUES(8,  5, '11.01.2022', 'MBlo',  65);
INSERT INTO exa_vente VALUES(9,  9, '13.01.2022', 'XNie',  33);
INSERT INTO exa_vente VALUES(10, 4, '14.01.2022', 'VBol', 900);
INSERT INTO exa_vente VALUES(11, 5, '14.01.2022', 'EMus',  66);
INSERT INTO exa_vente VALUES(12, 1, '14.01.2022', 'BArn', 160);
INSERT INTO exa_vente VALUES(13, 8, '17.01.2022', 'JBez', 800);
INSERT INTO exa_vente VALUES(14, 1, '17.01.2022', 'SBal', 160);
INSERT INTO exa_vente VALUES(15, 1, '18.01.2022', 'BGat', 165);
INSERT INTO exa_vente VALUES(16, 2, '18.01.2022', 'JBez', 125);
COMMIT;
