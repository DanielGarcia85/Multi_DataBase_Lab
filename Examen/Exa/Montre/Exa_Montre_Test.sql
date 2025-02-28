ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

SELECT * FROM exa_montre ORDER BY mon_marque, mon_modele;
SELECT * FROM vw_exa_livraison ORDER BY "Marque", "Modele";

INSERT INTO vw_exa_livraison VALUES('19.01.2022', 'Cartier', 'Secret', 20);
INSERT INTO vw_exa_livraison VALUES('19.01.2022', 'Flick', 'Flack', 20);
INSERT INTO vw_exa_livraison VALUES('11.11.2023', 'Flick', 'Flack', 20);
INSERT INTO vw_exa_livraison VALUES('11.11.2023', 'Rolex', 'Daytona', 20);
ROLLBACK;
COMMIT;

SELECT * FROM exa_vente;
SELECT * FROM exa_montre ORDER BY mon_marque, mon_modele;
INSERT INTO exa_vente VALUES(NULL, 3, '19.01.2022', 'ChSt', 750);

/
BEGIN
pkg_exa_montre.AfficherStat('Cartier');
dbms_output.new_line;
pkg_exa_montre.AfficherStat('Swatch');
dbms_output.new_line;
pkg_exa_montre.AfficherStat('Cartier', TRUE);
dbms_output.new_line;
pkg_exa_montre.AfficherStat('Swatch', FALSE);


