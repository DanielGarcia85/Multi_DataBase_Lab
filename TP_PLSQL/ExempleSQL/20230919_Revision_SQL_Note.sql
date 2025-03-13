/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01-Révision.sql             Auteur : Ch. Stettler
Objet  : Révision LDD (Create/Alter/Drop)  &  LMD (SELECT/Insert/Update/Delete)
---------------------------------------------------------------------------- */

--F8 pour executer, selectionner plusieurs ligne pour executer plusieurs ligne

--Standards de dénomination => respectez la casse : MOTS RESERVERS en MAJUSCULE, tout le rest en minuscule
--Exemple:
SELECT nomDunChamp FROM nomDeLaTable;
SELECT * FROM employe;
INSERT intp xxxx;

--Pour les noms:
--De table: le prefixe c'est 3 lettres, pour le domaine
CREATE TABLE prefixe_nomDeLaTable(
--De champs: le prefixe c'est le 3 premières lettres de la table
prefixe_nom
);

--Exemple:
DROP TABLE exe_employe;
DROP TABLE exe_dept;

CREATE TABLE exe_dept(
      dep_no NUMBER(5) CONSTRAINT pk_exe_dept PRIMARY KEY,
      dep_nom VARCHAR2(20) CONSTRAINT uk_dep_nom UNIQUE
);

CREATE TABLE exe_employe (
       emp_no            NUMBER(5)       CONSTRAINT pk_exe_employe PRIMARY KEY,
       emp_prenom        VARCHAR2(20),
       emp_nom           VARCHAR2(20)    CONSTRAINT nn_emp_nom NOT NULL,
       emp_embauche      DATE DEFAULT    SYSDATE CONSTRAINT nn_emp_embauch NOT NULL,
       emp_salaire       NUMBER (8,2)    CONSTRAINT ch_emp_salaire CHECK (emp_salaire > 0),
       emp_dep_no        NUMBER (5)      CONSTRAINT fk_exe_employe_dept REFERENCE exe_dept (dep_no)
       --Entre parenthèse c'est la taille (nombre de caractère)
);

--Instruction du LDD => Langage du Définition des Données => contenant/structure  => CREAT ALTER DROP

ALTER TABLE exe_employe ADD (emp_adresse VARCHAR2(20));
ALTER TABLE exe_employe MODIFY (emp_adresse VARCHAR2(50));
ALTER TABLE exe_employe DROP (emp_adresse);

ALTER TABLE exe_employe MODIFY (emp_nom VARCHAR2(25));

ALTER TABLE exe_employe MODIFY (emp_no CONSTRAINT pk_exe_employe PRIMARY KEY);

ALTER TABLE exe_employe ADD (emp_dep_no NUMBER (5) CONSTRAINT fk_exe_employe_dept REFERENCES exe_dept(dep_no));

--Instruction du LMD => Langage de Manipulation des Données => contenu (données/lignes/enregistrements) => INSERT UPDATE DELETE SELECT

INSERT INTO exe_dept VALUES (1,'RH');
INSERT INTO exe_dept VALUES (2,'Achat');
INSERT INTO exe_dept VALUES (3,'Vente');
INSERT INTO exe_dept VALUES (4,'Marketing');
INSERT INTO exe_dept VALUES (5,'Production');
COMMIT;
--Le commit sert à valider/sauver 'en gros' les données, car sans le commit une autre application qui veut accéder à la même bdd ne vera pas les données

INSERT INTO exe_employe VALUES (1,'Paul','Dupond','01.01.2020', 5000, 1);
INSERT INTO exe_employe VALUES (2,'John','Dufour','01.09.2023', 7000, 2);
INSERT INTO exe_employe VALUES (3,'Alan','Durand','01.10.2022', 5555, NULL);
INSERT INTO exe_employe VALUES (4,'Dany','Dupuis','01.01.2010', NULL, 1);
COMMIT;

UPDATE exe_employe SET emp_salaire=6666 WHERE emp_no=2;
UPDATE exe_employe SET emp_nom = 'Duma' WHERE emp_no=1;
COMMIT;

--ROLLBACK ??


SELECT * FROM exe_employe;
SELECT emp_prenom, emp_nom FROM exe_employe;         -- certains champs (colonnes)
SELECT * FROM exe_employe WHERE emp_salaire > 5000;  -- seulement certains enregistrements

SELECT * FROM exe_employe INNER JOIN exe_dept ON dep_no = emp_dep_no; -- jointure interne
--Seuls les enregstriement dans les 2 tables sont affichés (INNER JOIN par défaut si on met rien)

SELECT * FROM exe_employe LEFT JOIN exe_dept ON dep_no = emp_dep_no; --jointure externe
--Pour avoir tous les enregsitrement de la table de gauche (avant le JOIN)

SELECT * FROM exe_employe RIGHT JOIN exe_dept ON dep_no = emp_dep_no;
--Pour avoir tous les enregsitrement de la table de droite (après le JOIN)

SELECT * FROM exe_employe FULL JOIN exe_dept ON dep_no = emp_dep_no;
--Pour avoir tous les enregsitrement des deux tables (à droite et à gauche du JOINT)

--Statistique
SELECT COUNT(*) FROM exe_employe;             -- nombre d'enregistrement
SELECT COUNT(emp_salaire) FROM exe_employe;   -- nombre de valeurs dans ce champ
SELECT SUM(emp_salaire) "Total des salaires à verser", AVG(emp_salaire) "Salaire moyen" FROM exe_employe;

--Le select standard à savoir coder "rapidement"
--Le select le plus "corsé"
-- afficher la liste des employés qui gagnent plus que Dupond :
SELECT emp_salaire FROM exe_employe WHERE LOWER(emp_nom)='dupond';
--ou
SELECT * FROM exe_employe WHERE emp_salaire > (SELECT emp_salaire FROM exe_employe WHERE LOWER(emp_nom)='dupond');
--ou
SELECT emp_nom, emp_prenom, emp_salaire, emp_salaire*12 "Salaire annuel", dep_nom
       FROM exe_employe
       LEFT JOIN exe_dept ON dept_no = emp_dep_no;
       WHERE emp_salaire > (SELECT emp_salaire FROM exe_employe WHERE LOWER (emp_nom) = 'Dupond');

SELECT emp_dep_no, COUNT(*) "Nombre d'employés", AVG(emp_salaire) "Salaire moyen"
       FROM exe_employe
       GROUP BY emp_dep_no;
       
SELECT dep_nom, COUNT(emp_no) "Nombre d'employés", AVG(emp_salaire) "Salaire moyen"
       FROM exe_employe RIGHT JOIN exe_dept ON dep_no = emp_dep_no
       GROUP BY dep_nom;
