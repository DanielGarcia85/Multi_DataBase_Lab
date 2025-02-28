ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

BEGIN
  --cc_2022.v_tri := 'nb_joue';
  --cc_2022.v_tri := 'com_debut';
  --cc_2022.v_tri := 'com_nom';
  cc_2022.QuiPeutJouerACetteDate('20/10/2022');
  cc_2022.QuiPeutJouerACetteDate('22/10/2022');
  cc_2022.QuiPeutJouerACetteDate('24/10/2022');
  cc_2022.QuiPeutJouerACetteDate('26/10/2022');
  cc_2022.QuiPeutJouerACetteDate('28/10/2022');
END;
