SELECT * FROM vw_exa_transports;
SELECT * FROM exa_transport;
SELECT * FROM exa_colis;
SELECT * FROM exa_agence;
SELECT * FROM exa_log_agence_1;
SELECT * FROM exa_colis WHERE col_age_depart = 1 AND col_age_arrivee = 3;
SELECT * FROM exa_colis WHERE col_age_depart = 1 AND col_age_arrivee = 3 AND col_tra_no is NULL ORDER BY col_poids DESC;
INSERT INTO vw_exa_transports (poids_max, depart, arrivee) VALUES (1, 1, 4);
INSERT INTO vw_exa_transports (poids_max, depart, arrivee) VALUES (200, 1, 6);
UPDATE vw_exa_transports SET poids_max = 999, poids_colis = 777 WHERE numero = 5;
DELETE vw_exa_transports WHERE numero = 3;
