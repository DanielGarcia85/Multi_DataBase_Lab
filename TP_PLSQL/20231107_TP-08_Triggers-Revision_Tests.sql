/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 08-Revision-Trigger.sql      Auteur: Ch. Stettler
Objet  : Révision Triggers - Modèle Personne-Emploi-Domicile - Jeux de tests
---------------------------------------------------------------------------- */

-- =======================================================================================
-- 1) Vue : Liste des personnes avec tous leurs emplois
-- =======================================================================================

SELECT * FROM vw_rev_lst_emplois;
UPDATE vw_rev_lst_emplois SET "Salaire" = 2222;
UPDATE vw_rev_lst_emplois SET "Salaire" = 2000 WHERE "N° personne" = 7 AND "N° entreprise" = 6;
DELETE FROM vw_rev_lst_emplois WHERE "N° personne" = 7 AND "N° entreprise" = 6;
INSERT INTO vw_rev_lst_emplois ("N° personne", "N° entreprise", "Date début", "Salaire") VALUES (10, 1, to_date('01-10-2021', 'dd-mm-yyyy'), 4000);
ROLLBACK; 

-- =======================================================================================
-- 2) Trigger : Nouvel emploi
-- =======================================================================================

SELECT * FROM vw_rev_lst_emplois WHERE "N° personne" = 7;
INSERT INTO vw_rev_lst_emplois ("N° personne", "N° entreprise",               "Date début", "Salaire") VALUES (7, 1,                to_date('01-05-2020', 'dd-mm-yyyy'), 4000);
INSERT INTO vw_rev_lst_emplois ("N° personne", "N° entreprise", "Entreprise", "Date début", "Salaire") VALUES (7, 20, 'HEG-Genève', to_date('01-11-2021', 'dd-mm-yyyy'), 4000);
ROLLBACK;
COMMIT;

-- =======================================================================================
-- 3) Trigger : Insertion domicile + Statistique
-- =======================================================================================

INSERT INTO rev_domicile VALUES (21, to_date('01-04-2020', 'dd-mm-yyyy'), NULL, 10, 1);
INSERT INTO rev_domicile VALUES (22, to_date('01-01-2021', 'dd-mm-yyyy'), NULL, 20, 1);
INSERT INTO rev_domicile VALUES (23, to_date('01-12-2021', 'dd-mm-yyyy'), NULL, 22, 1);
INSERT INTO rev_domicile VALUES (24, to_date('01-05-2020', 'dd-mm-yyyy'), NULL, 33, 5);
INSERT INTO rev_domicile VALUES (25, to_date('01-11-2021', 'dd-mm-yyyy'), NULL, 44, 5);
ROLLBACK;
COMMIT;

SELECT * FROM rev_statistique;
SELECT * FROM rev_domicile;
