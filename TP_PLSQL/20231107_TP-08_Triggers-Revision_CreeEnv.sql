/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 08-Revision-Trigger-CreerEnv.sql Auteur: Stettler
Objet  : Révision Triggers - Modèle Personne-Emploi-Domicile - Création et remplissage des tables
---------------------------------------------------------------------------- */

DROP TABLE rev_domicile;
DROP TABLE rev_localite;
DROP TABLE rev_emplois;
DROP TABLE rev_entreprise;
DROP TABLE rev_statistique;
DROP TABLE rev_personne;

CREATE TABLE rev_personne (
   per_no            NUMBER(6)  CONSTRAINT pk_rev_personne PRIMARY KEY,
   per_nom           VARCHAR2(50),
   per_prenom        VARCHAR2(50)
);

CREATE TABLE rev_statistique (
   sta_no            NUMBER(6)  CONSTRAINT pk_rev_statistique PRIMARY KEY,
   sta_nb_change     NUMBER(3),
   sta_remarques     VARCHAR2(50),
   sta_per_no        NUMBER(6)  CONSTRAINT fk_rev_statistique_personne REFERENCES rev_personne (per_no)
);

CREATE TABLE rev_entreprise (
   ent_no            NUMBER(6)  CONSTRAINT pk_rev_entreprise PRIMARY KEY,
   ent_nom           VARCHAR2(50)
);

CREATE TABLE rev_emplois (
   emp_ent_no        NUMBER(6)  CONSTRAINT fk_rev_emploi_entreprise REFERENCES rev_entreprise (ent_no),
   emp_per_no        NUMBER(6)  CONSTRAINT fk_rev_emploi_personne   REFERENCES rev_personne (per_no),
   emp_date_debut    DATE,
   emp_salaire       NUMBER(8,2),
   CONSTRAINT pk_rev_emplois PRIMARY KEY (emp_ent_no, emp_per_no)
);

CREATE TABLE rev_localite (
   loc_no            NUMBER(6)  CONSTRAINT pk_rev_localite PRIMARY KEY,
   loc_npa           CHAR(4),
   loc_nom           VARCHAR2(40)
);

CREATE TABLE rev_domicile (
   dom_no            NUMBER(6)  CONSTRAINT pk_rev_domicile PRIMARY KEY,
   dom_date_arrivee  DATE,
   dom_date_depart   DATE,
   dom_loc_no        NUMBER(6)  CONSTRAINT fk_rev_domicile_localite REFERENCES rev_localite (loc_no),
   dom_per_no        NUMBER(6)  CONSTRAINT fk_rev_domicile_personne REFERENCES rev_personne (per_no)
);

INSERT INTO rev_personne VALUES (1,'BON',     'Jean');
INSERT INTO rev_personne VALUES (2,'REMORD',  'Yves');
INSERT INTO rev_personne VALUES (3,'TERIEUR', 'Alex');
INSERT INTO rev_personne VALUES (4,'PROVISTE','Alain');
INSERT INTO rev_personne VALUES (5,'TERIEUR', 'Alain');
INSERT INTO rev_personne VALUES (6,'DISSOIRE','Sam');
INSERT INTO rev_personne VALUES (7,'DORSA',   'Elsa');
INSERT INTO rev_personne VALUES (8,'POSTEUR', 'alain');
INSERT INTO rev_personne VALUES (9,'ONYME',   'Anne');
INSERT INTO rev_personne VALUES (10,'DOEUF',  'John');
COMMIT;

INSERT INTO rev_statistique VALUES (1, 2, NULL, 1);
INSERT INTO rev_statistique VALUES (2, 4, 'A la bougeotte', 4);
INSERT INTO rev_statistique VALUES (3, 4, 'Ne reste jamais bien longtemps', 6);
INSERT INTO rev_statistique VALUES (4, 3, NULL, 8);
INSERT INTO rev_statistique VALUES (5, 2, NULL, 10);
COMMIT;

INSERT INTO rev_entreprise VALUES (1, 'Vugliano R. & Cie');
INSERT INTO rev_entreprise VALUES (2, 'Kempinski SA');
INSERT INTO rev_entreprise VALUES (3, 'Dentella SA');
INSERT INTO rev_entreprise VALUES (4, 'Dentago SA');
INSERT INTO rev_entreprise VALUES (5, 'DaniRénovation');
INSERT INTO rev_entreprise VALUES (6, 'Entreprise Grand');
INSERT INTO rev_entreprise VALUES (7, 'Nicod Bernard SA');
INSERT INTO rev_entreprise VALUES (8, 'Costa SA');
INSERT INTO rev_entreprise VALUES (9, 'Guimet V. Fils SA');
INSERT INTO rev_entreprise VALUES (10, 'Christo SA');
COMMIT;

INSERT INTO rev_emplois VALUES (1, 5, to_date('25-06-1999', 'dd-mm-yyyy'), 10250);
INSERT INTO rev_emplois VALUES (2, 6, to_date('20-06-2003', 'dd-mm-yyyy'), 4250);
INSERT INTO rev_emplois VALUES (2, 1, to_date('21-06-2008', 'dd-mm-yyyy'), 3600);
INSERT INTO rev_emplois VALUES (4, 9, to_date('15-06-2005', 'dd-mm-yyyy'), 2400);
INSERT INTO rev_emplois VALUES (4, 8, to_date('05-06-2000', 'dd-mm-yyyy'), 5500);
INSERT INTO rev_emplois VALUES (4, 3, to_date('08-06-1998', 'dd-mm-yyyy'), 5800);
INSERT INTO rev_emplois VALUES (4, 4, to_date('18-06-2006', 'dd-mm-yyyy'), 5100);
INSERT INTO rev_emplois VALUES (6, 3, to_date('28-06-2004', 'dd-mm-yyyy'), 4500);
INSERT INTO rev_emplois VALUES (6, 7, to_date('26-06-2000', 'dd-mm-yyyy'), 4300);
INSERT INTO rev_emplois VALUES (7, 3, to_date('06-06-2009', 'dd-mm-yyyy'), 12600);
INSERT INTO rev_emplois VALUES (8, 9, to_date('01-06-2001', 'dd-mm-yyyy'), 9865);
INSERT INTO rev_emplois VALUES (9, 3, to_date('05-06-1985', 'dd-mm-yyyy'), 6580);
INSERT INTO rev_emplois VALUES (9, 7, to_date('13-06-1996', 'dd-mm-yyyy'), 8630);
INSERT INTO rev_emplois VALUES (9, 9, to_date('29-06-1999', 'dd-mm-yyyy'), 7700);
COMMIT;

INSERT INTO rev_localite VALUES (1, 1288, 'Aire-la-Ville');
INSERT INTO rev_localite VALUES (2, 1247, 'Anières');
INSERT INTO rev_localite VALUES (3, 1237, 'Avully');
INSERT INTO rev_localite VALUES (4, 1285, 'Avusy');
INSERT INTO rev_localite VALUES (5, 1257, 'Bardonnex');
INSERT INTO rev_localite VALUES (6, 1293, 'Bellevue');
INSERT INTO rev_localite VALUES (7, 1233, 'Bernex');
INSERT INTO rev_localite VALUES (8, 1227, 'Carouge');
INSERT INTO rev_localite VALUES (9, 1236, 'Cartigny');
INSERT INTO rev_localite VALUES (10, 1298, 'Céligny');
INSERT INTO rev_localite VALUES (11, 1284, 'Chancy');
INSERT INTO rev_localite VALUES (12, 1224, 'Chêne-Bougeries');
INSERT INTO rev_localite VALUES (13, 1225, 'Chêne-Bourg');
INSERT INTO rev_localite VALUES (14, 1244, 'Choulex');
INSERT INTO rev_localite VALUES (15, 1239, 'Collex-Bossy');
INSERT INTO rev_localite VALUES (16, 1245, 'Collonge-Bellerive');
INSERT INTO rev_localite VALUES (17, 1223, 'Cologny');
INSERT INTO rev_localite VALUES (18, 1232, 'Confignon');
INSERT INTO rev_localite VALUES (19, 1246, 'Corsier');
INSERT INTO rev_localite VALUES (20, 1282, 'Dardagny');
INSERT INTO rev_localite VALUES (21, 1200, 'Genève');
INSERT INTO rev_localite VALUES (22, 1294, 'Genthod');
INSERT INTO rev_localite VALUES (23, 1251, 'Gy');
INSERT INTO rev_localite VALUES (24, 1248, 'Hermance');
INSERT INTO rev_localite VALUES (25, 1254, 'Jussy');
INSERT INTO rev_localite VALUES (26, 1287, 'Laconnex');
INSERT INTO rev_localite VALUES (27, 1212, 'Lancy');
INSERT INTO rev_localite VALUES (28, 1218, 'Le Grand-Saconnex');
INSERT INTO rev_localite VALUES (29, 1252, 'Meinier');
INSERT INTO rev_localite VALUES (30, 1217, 'Meyrin');
INSERT INTO rev_localite VALUES (31, 1213, 'Onex');
INSERT INTO rev_localite VALUES (32, 1258, 'Perly-Certoux');
INSERT INTO rev_localite VALUES (33, 1228, 'Plan-les-Ouates');
INSERT INTO rev_localite VALUES (34, 1292, 'Pregny-Chambésy');
INSERT INTO rev_localite VALUES (35, 1243, 'Presinge');
INSERT INTO rev_localite VALUES (36, 1241, 'Puplinge');
INSERT INTO rev_localite VALUES (37, 1281, 'Russin');
INSERT INTO rev_localite VALUES (38, 1242, 'Satigny');
INSERT INTO rev_localite VALUES (39, 1286, 'Soral');
INSERT INTO rev_localite VALUES (40, 1226, 'Thônex');
INSERT INTO rev_localite VALUES (41, 1256, 'Troinex');
INSERT INTO rev_localite VALUES (42, 1253, 'Vandœuvres');
INSERT INTO rev_localite VALUES (43, 1214, 'Vernier');
INSERT INTO rev_localite VALUES (44, 1290, 'Versoix');
INSERT INTO rev_localite VALUES (45, 1255, 'Veyrier');
COMMIT;

INSERT INTO rev_domicile VALUES (1, to_date('03-05-1967', 'dd-mm-yyyy'), to_date('31-12-2008', 'dd-mm-yyyy'), 44, 1);
INSERT INTO rev_domicile VALUES (2, to_date('01-01-2009', 'dd-mm-yyyy'), NULL, 22, 1);
INSERT INTO rev_domicile VALUES (3, to_date('21-04-1954', 'dd-mm-yyyy'), NULL, 39, 3);
INSERT INTO rev_domicile VALUES (4, to_date('14-01-1958', 'dd-mm-yyyy'), to_date('24-11-1956', 'dd-mm-yyyy'), 1, 4);
INSERT INTO rev_domicile VALUES (5, to_date('25-11-1965', 'dd-mm-yyyy'), to_date('08-10-1963', 'dd-mm-yyyy'), 38, 4);
INSERT INTO rev_domicile VALUES (6, to_date('09-10-2002', 'dd-mm-yyyy'), NULL, 28, 4);
INSERT INTO rev_domicile VALUES (7, to_date('13-03-1972', 'dd-mm-yyyy'), to_date('17-09-1996', 'dd-mm-yyyy'), 28, 4);
INSERT INTO rev_domicile VALUES (8, to_date('18-09-1996', 'dd-mm-yyyy'), to_date('12-11-1996', 'dd-mm-yyyy'), 15, 6);
INSERT INTO rev_domicile VALUES (9, to_date('12-11-1996', 'dd-mm-yyyy'), to_date('21-11-1998', 'dd-mm-yyyy'), 20, 6);
INSERT INTO rev_domicile VALUES (10, to_date('22-11-1998', 'dd-mm-yyyy'), to_date('02-07-2004', 'dd-mm-yyyy'), 34, 6);
INSERT INTO rev_domicile VALUES (11, to_date('03-07-2004', 'dd-mm-yyyy'), NULL, 12, 6);
INSERT INTO rev_domicile VALUES (12, to_date('30-11-1956', 'dd-mm-yyyy'), to_date('24-11-1998', 'dd-mm-yyyy'), 25, 7);
INSERT INTO rev_domicile VALUES (13, to_date('06-01-1963', 'dd-mm-yyyy'), to_date('11-06-1996', 'dd-mm-yyyy'), 19, 8);
INSERT INTO rev_domicile VALUES (14, to_date('12-06-1996', 'dd-mm-yyyy'), to_date('31-12-2008', 'dd-mm-yyyy'), 7, 8);
INSERT INTO rev_domicile VALUES (15, to_date('01-01-2009', 'dd-mm-yyyy'), NULL, 10, 8);
INSERT INTO rev_domicile VALUES (16, to_date('16-02-1956', 'dd-mm-yyyy'), to_date('24-02-2000', 'dd-mm-yyyy'), 18, 10);
INSERT INTO rev_domicile VALUES (17, to_date('25-02-2000', 'dd-mm-yyyy'), NULL, 12, 10);
COMMIT;
