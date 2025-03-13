create or replace package cc_2021 is

  PROCEDURE creerCommande(i_fou_no cc_fournisseur.fou_no%TYPE);
  PROCEDURE creerCommande(i_fou_nom cc_fournisseur.fou_nom%TYPE);
  
end cc_2021;
/
create or replace package body cc_2021 is

  PROCEDURE creerCommande(i_fou_no cc_fournisseur.fou_no%TYPE) IS
    CURSOR crs_pro_a_commande IS SELECT * FROM cc_produit JOIN cc_fournisseur ON pro_fou_no = fou_no WHERE pro_stock < pro_seuil AND fou_no = i_fou_no;
    TYPE PRO_A_COMMANDE IS RECORD (pro_no cc_produit.pro_no%TYPE, pro_nom cc_produit.pro_nom%TYPE, pro_stock cc_produit.pro_stock%TYPE, pro_prix_achat cc_produit.pro_prix_achat%TYPE, pro_prix_vente cc_produit.pro_prix_vente%TYPE, pro_seuil cc_produit.pro_seuil%TYPE, pro_lot cc_produit.pro_lot%TYPE, pro_fou_no cc_produit.pro_fou_no%TYPE, fou_no cc_fournisseur.fou_no%TYPE, fou_nom cc_fournisseur.fou_nom%TYPE, fou_detail cc_fournisseur.fou_detail%TYPE);
    v_pro_a_commande PRO_A_COMMANDE;
    v_fou_nom cc_fournisseur.fou_nom%TYPE;
    v_com_no cc_commande.com_no%TYPE;
    v_com_total cc_produit.pro_prix_achat%TYPE;
    err_pas_de_pro_a_commande EXCEPTION;
    err_montant_total_min EXCEPTION;
    err_pro_dej_commande EXCEPTION;
    PRAGMA EXCEPTION_INIT(err_pro_dej_commande, -00001);
  BEGIN
    SELECT fou_nom INTO v_fou_nom FROM cc_fournisseur WHERE fou_no = i_fou_no;
    OPEN crs_pro_a_commande;
    FETCH crs_pro_a_commande INTO v_pro_a_commande;
    IF crs_pro_a_commande%NOTFOUND THEN RAISE err_pas_de_pro_a_commande; END IF;
    SELECT NVL(MAX(com_no), 0)+1 INTO v_com_no FROM cc_commande;
    INSERT INTO cc_commande VALUES(v_com_no, SYSDATE, v_com_total, v_pro_a_commande.fou_no);
    v_com_total := 0;
    WHILE crs_pro_a_commande%FOUND LOOP
      v_com_total := v_com_total + v_pro_a_commande.pro_lot * v_pro_a_commande.pro_prix_achat;
      INSERT INTO cc_ligne_cmde VALUES(v_com_no, v_pro_a_commande.pro_no, v_pro_a_commande.pro_lot);
      FETCH crs_pro_a_commande INTO v_pro_a_commande;
    END LOOP;
    IF v_com_total < 100 THEN
      DELETE cc_ligne_cmde WHERE lig_com_no = v_com_no; 
      DELETE cc_commande WHERE com_no = v_com_no;
      RAISE err_montant_total_min;
    END IF;
    UPDATE cc_commande SET com_total = v_com_total WHERE com_no = v_com_no;
    dbms_output.put_line('Commande N°' || v_com_no || ' pour un montant de '|| v_com_total || ' CHF est validée');
    CLOSE crs_pro_a_commande;
  EXCEPTION
    WHEN err_pas_de_pro_a_commande THEN dbms_output.put_line('Il n''a pas de produit à commander pour le fournisseur : ' || v_fou_nom);
    WHEN no_data_found THEN dbms_output.put_line('Il n''y a aucune fournisseur dans la base de donnée correspondand au fournisseur fournit en paramètre');
    WHEN err_montant_total_min THEN dbms_output.put_line('La commande n''atteint pas le montant minimal de 100 CHF pour être validée');
    WHEN err_pro_dej_commande THEN dbms_output.put_line('Produit déjà commandé !');
  END creerCommande;
  
  PROCEDURE creerCommande (i_fou_nom cc_fournisseur.fou_nom%TYPE) IS
    CURSOR crs_fou_no IS SELECT fou_no FROM cc_fournisseur WHERE LOWER(fou_nom) = LOWER(i_fou_nom);
    v_fou_no crs_fou_no%ROWTYPE;
  BEGIN
    OPEN crs_fou_no;
    FETCH crs_fou_no INTO v_fou_no;
    IF crs_fou_no%NOTFOUND THEN RAISE no_data_found; END IF;
    WHILE crs_fou_no%FOUND LOOP
      creerCommande(v_fou_no.fou_no);
      FETCH crs_fou_no INTO v_fou_no;
    END LOOP;
    CLOSE crs_fou_no;
  EXCEPTION
    WHEN no_data_found THEN dbms_output.put_line('Il n''y a aucune fournisseur dans la base de donnée correspondand au fournisseur fournit en paramètre');
  END creerCommande;

end cc_2021;
/
