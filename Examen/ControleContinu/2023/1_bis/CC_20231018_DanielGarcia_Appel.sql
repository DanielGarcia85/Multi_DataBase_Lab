
BEGIN
  --cc_2023.afficherVentesDeCourges(2022, '>=');
  --cc_2023.afficherVentesDeCourges(2011, '<');
  --cc_2023.afficherVentesDeCourges(2017, '=');
  --cc_2023.afficherVentesDeCourges(2019, '=');
  --cc_2023.afficherVentesDeCourges(2017, '=');
  --cc_2023.afficherVentesDeCourges(2017, '>');
  --cc_2023.afficherVentesDeCourges(2017, '!=');
  --cc_2023.afficherVentesDeCourges(2019, '<>');
END;

/ 
SELECT ven_annee, ven_nb FROM cc_vente JOIN cc_courge ON cou_no = ven_cou_no WHERE ven_nb IS NOT NULL AND cou_nom = 'Potiron' ORDER BY ven_annee DESC;





