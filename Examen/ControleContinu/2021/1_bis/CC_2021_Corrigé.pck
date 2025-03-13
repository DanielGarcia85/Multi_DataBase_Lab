create or replace package pkg_cc2021 is

  PROCEDURE CreerCommande(i_fou_no IN cc_fournisseur.fou_no%TYPE);
  PROCEDURE CreerCommande(i_fou_nom IN cc_fournisseur.fou_nom%TYPE);
  FUNCTION numCommande RETURN cc_commande.com_no%TYPE;



end pkg_cc2021;
/
create or replace package body pkg_cc2021 IS

    v_REGLE INTEGER := 100;
    PROCEDURE CreerCommande(i_fou_no IN cc_fournisseur.fou_no%TYPE) IS 
      CURSOR c_prod IS
         SELECT * FROM cc_produit JOIN cc_fournisseur ON pro_fou_no = fou_no WHERE fou_no = i_fou_no;      
      v_comTotal INTEGER := 0;     
      v_numCommande cc_commande.com_no%TYPE;     
      BEGIN       
       v_numCommande := numCommande;
       FOR v_prod IN c_prod LOOP       
          IF v_prod.pro_seuil > v_prod.pro_stock THEN          
            v_comTotal := v_comTotal + v_prod.pro_lot * v_prod.pro_prix_achat;
          END IF;
       END LOOP;           
       IF v_comTotal > v_REGLE THEN
              INSERT INTO cc_commande VALUES (
              v_numCommande, 
              SYSDATE,
              v_comTotal,
              i_fou_no
              );      
       FOR v_prod IN c_prod LOOP        
           IF v_prod.pro_seuil > v_prod.pro_stock THEN          
            INSERT INTO cc_ligne_cmde VALUES (
            v_numCommande,
            v_prod.pro_no,
            v_prod.pro_lot
            );
            END IF;           
       END LOOP;
       END IF;      
      END CreerCommande;
        
    PROCEDURE CreerCommande(i_fou_nom IN cc_fournisseur.fou_nom%TYPE) IS       
      CURSOR c_four IS SELECT fou_no FROM cc_fournisseur WHERE fou_nom = i_fou_nom;
     BEGIN 
        FOR v_four IN c_four LOOP
          CreerCommande(v_four.fou_no);
        END LOOP;       
      END CreerCommande;


    FUNCTION numCommande RETURN cc_commande.com_no%TYPE IS 
      v_temp cc_commande.com_no%TYPE;
      v_com_no cc_commande.com_no%TYPE;
      BEGIN
        SELECT max(com_no) INTO v_temp FROM cc_commande;
        IF v_temp IS NULL THEN
          RETURN 1;
        ELSE 
          SELECT MAX(com_no) INTO v_com_no FROM cc_commande;
          RETURN v_com_no +1;
        END IF;
      
      EXCEPTION 
        WHEN no_data_found THEN 
          RETURN 1;     
      END numCommande;
    
end pkg_cc2021;
/
