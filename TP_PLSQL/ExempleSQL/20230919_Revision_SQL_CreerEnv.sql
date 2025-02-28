/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01-Exemple-CreerEnv.sql     Auteur : Ch. Stettler
Objet  : Création et remplissage des tables d'exemple
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';

DROP TABLE exe_employe;
DROP TABLE exe_dept;

CREATE TABLE exe_dept (
   dep_no       NUMBER(5)    CONSTRAINT pk_exe_dept PRIMARY KEY,
   dep_nom      VARCHAR2(20) CONSTRAINT uk_dep_nom UNIQUE
);

CREATE TABLE exe_employe (
   emp_no       NUMBER(5)    CONSTRAINT pk_exe_employe PRIMARY KEY,
   emp_prenom   VARCHAR2(20),
   emp_nom      VARCHAR2(20) CONSTRAINT nn_emp_nom     NOT NULL,
   emp_embauche DATE DEFAULT SYSDATE CONSTRAINT nn_emp_embauche NOT NULL,
   emp_salaire  NUMBER(8,2)  CONSTRAINT ch_emp_salaire CHECK (emp_salaire > 0),
   emp_dep_no   NUMBER(5)    CONSTRAINT fk_exe_employe_dept REFERENCES exe_dept (dep_no)
);

INSERT INTO exe_dept VALUES (1,'RH');
INSERT INTO exe_dept VALUES (2,'Achat');
INSERT INTO exe_dept VALUES (3,'Vente');
INSERT INTO exe_dept VALUES (4,'Marketing');
INSERT INTO exe_dept VALUES (5,'Production');
COMMIT; 

INSERT INTO exe_employe VALUES (1,'Jean', 'BON',      '01.01.2020', 5000, 1);
INSERT INTO exe_employe VALUES (2,'Yves', 'REMORD',   '01.08.2018', 4000, 3);
INSERT INTO exe_employe VALUES (3,'Alex', 'TERIEUR',  '01.03.2013', 6000, NULL);
INSERT INTO exe_employe VALUES (4,'Alain','PROVISTE', '01.02.2022', 8000, 4);
INSERT INTO exe_employe VALUES (5,'Alain','TERIEUR',  '01.06.2016', 5000, 5);
INSERT INTO exe_employe VALUES (6,'Sam',  'DISSOIRE',  DEFAULT,     5000, 4);
INSERT INTO exe_employe VALUES (7,'Elsa', 'DORSA',    '01.01.2000', 7000, 3);
INSERT INTO exe_employe VALUES (8,'alain','POSTEUR',  '01.09.2023', NULL, 5);
INSERT INTO exe_employe VALUES (9,'Anne', 'ONYME',    '01.09.2019', 6000, 5);
COMMIT;
