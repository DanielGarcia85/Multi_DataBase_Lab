


BEGIN 
    pkg_CC2021.CreerCommande('HomeShop');
    pkg_cc2021.CreerCommande(1);
    pkg_cc2021.CreerCommande(6);
    pkg_cc2021.CreerCommande('ACME');
    
END;
/

SELECT * FROM cc_commande JOIN cc_ligne_cmde ON com_no = lig_com_no;


SELECT * FROM cc_commande;

SELECT fou_no FROM cc_fournisseur WHERE fou_nom = 'ACME';

SELECT * FROM cc_fournisseur;

SELECT * FROM exe_employe;

DROP TABLE cc_commande;

SELECT * FROM cc_produit JOIN cc_fournisseur ON pro_fou_no = fou_no WHERE fou_no = 3;
