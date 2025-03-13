
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

BEGIN
  DELETE FROM cc_ligne_cmde;
  DELETE FROM cc_commande;
  cc_2021.creerCommande('homeshop');
  cc_2021.creerCommande(1);
  cc_2021.creerCommande(6);
  cc_2021.creerCommande('acme');
  cc_2021.creerCommande(84);
  cc_2021.creerCommande('nonoenfe');
  cc_2021.creerCommande(6);
  cc_2021.creerCommande(1);
  cc_2021.creerCommande(2);
  cc_2021.creerCommande(4);
  cc_2021.creerCommande(4);
END;



