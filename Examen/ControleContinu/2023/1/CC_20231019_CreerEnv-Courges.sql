/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - CC-Courges-CreerEnv.sql     Auteur : Ch. Stettler
Objet  : Création et remplissage des tables pour le CC du 18/10/2023 - Courges
---------------------------------------------------------------------------- */

DROP TABLE cc_vente;
DROP TABLE cc_courge;

CREATE TABLE cc_courge (
   cou_no     NUMBER(5)   CONSTRAINT pk_cc_courge PRIMARY KEY,
   cou_nom    VARCHAR2(20)
);

CREATE TABLE cc_vente (
   ven_annee  NUMBER(5),
   ven_cou_no NUMBER(5)   CONSTRAINT fk_cc_vente_courge REFERENCES cc_courge(cou_no),
   ven_nb     NUMBER(5),
   CONSTRAINT pk_cc_vente PRIMARY KEY (ven_annee, ven_cou_no)
);

CREATE OR REPLACE PACKAGE pkg_cc_outils IS
   AucuneVenteCetteAnnee EXCEPTION;
   TYPE TYPE_COURGE_VENDUE IS RECORD (cou_no cc_courge.cou_no%TYPE, cou_nom cc_courge.cou_nom%TYPE, ven_nb cc_vente.ven_nb%TYPE);
   FUNCTION MeilleureVente(i_ven_annee IN cc_vente.ven_annee%TYPE) RETURN TYPE_COURGE_VENDUE;
END pkg_cc_outils;
/
CREATE OR REPLACE PACKAGE BODY pkg_cc_outils IS
   FUNCTION MeilleureVente(i_ven_annee IN cc_vente.ven_annee%TYPE) RETURN TYPE_COURGE_VENDUE IS
      v_courgeVendue TYPE_COURGE_VENDUE;
   BEGIN
      SELECT * INTO v_courgeVendue FROM (SELECT cou_no, cou_nom, ven_nb FROM cc_courge JOIN cc_vente ON ven_cou_no=cou_no WHERE ven_annee=i_ven_annee AND ven_nb IS NOT NULL ORDER BY ven_nb DESC) WHERE ROWNUM=1;
      RETURN v_courgeVendue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN RAISE AucuneVenteCetteAnnee;
   END MeilleureVente;
END pkg_cc_outils;
/
INSERT INTO cc_courge VALUES (1, 'Butternut');
INSERT INTO cc_courge VALUES (2, 'Golias');
INSERT INTO cc_courge VALUES (3, 'Lady Godiva');
INSERT INTO cc_courge VALUES (4, 'Muscade');
INSERT INTO cc_courge VALUES (5, 'Potimarron');
INSERT INTO cc_courge VALUES (6, 'Potiron');
INSERT INTO cc_courge VALUES (7, 'Royal Acorn');
INSERT INTO cc_courge VALUES (8, 'Siam');
INSERT INTO cc_courge VALUES (9, 'Spaghetti');
INSERT INTO cc_courge VALUES (10,'Sweet Dumpling');
COMMIT;

INSERT INTO cc_vente VALUES (2017, 1, 111);
INSERT INTO cc_vente VALUES (2017, 5, 100);

INSERT INTO cc_vente VALUES (2018, 1, 200);
INSERT INTO cc_vente VALUES (2018, 4, 212);
INSERT INTO cc_vente VALUES (2018, 5, 222);
INSERT INTO cc_vente VALUES (2018, 9, 202);

INSERT INTO cc_vente VALUES (2019, 1, NULL);
INSERT INTO cc_vente VALUES (2019, 4, NULL);
INSERT INTO cc_vente VALUES (2019, 9, NULL);

INSERT INTO cc_vente VALUES (2020, 2, NULL);
INSERT INTO cc_vente VALUES (2020, 3, 321);
INSERT INTO cc_vente VALUES (2020, 6, 345);
INSERT INTO cc_vente VALUES (2020, 7, NULL);
INSERT INTO cc_vente VALUES (2020, 9, 333);

INSERT INTO cc_vente VALUES (2021, 1, 424);
INSERT INTO cc_vente VALUES (2021, 4, 404);
INSERT INTO cc_vente VALUES (2021, 5, 400);
INSERT INTO cc_vente VALUES (2021, 6, 440);
INSERT INTO cc_vente VALUES (2021, 9, 444);

INSERT INTO cc_vente VALUES (2022, 1, 555);
INSERT INTO cc_vente VALUES (2022, 3, 500);
INSERT INTO cc_vente VALUES (2022, 4, 567);
INSERT INTO cc_vente VALUES (2022, 5, 505);
INSERT INTO cc_vente VALUES (2022, 9, 550);
COMMIT;
