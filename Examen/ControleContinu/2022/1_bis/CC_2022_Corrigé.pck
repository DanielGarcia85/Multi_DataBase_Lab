create or replace package pkg_cc2022_faitEnClasse is


       PROCEDURE QuiPeutJouerACetteDate(i_date IN cc_representation.rep_date%TYPE);
       
       v_tri VARCHAR2(100) := 'nb_joue desc';  -- variable public !!
end pkg_cc2022_faitEnClasse;
/
create or replace package body pkg_cc2022_faitEnClasse IS

       --v_tri VARCHAR2(100) := 'nb_joue desc';

       PROCEDURE QuiPeutJouerACetteDate(i_date IN cc_representation.rep_date%TYPE) IS
         v_spe_no    cc_spectacle.spe_no%TYPE;
         v_spe_nom   cc_spectacle.spe_nom%TYPE;
         CURSOR c_repres IS SELECT spe_nom FROM cc_representation JOIN cc_spectacle ON spe_no=rep_spe_no WHERE rep_date=i_date;
       BEGIN
         OPEN c_repres;
         FETCH c_repres INTO v_spe_nom;
         IF c_repres%NOTFOUND THEN raise_application_error(-20000, 'Aucun spectacle ce jour-là'); END IF;
         WHILE c_repres%FOUND LOOP
           dbms_output.put_line('Liste des comédiens ayant déjà joué "' || v_spe_nom || '" :');
           
           DECLARE
              c_comediens SYS_REFCURSOR;
              v_comedien  cc_qui_a_joue_quoi%ROWTYPE;
           BEGIN
              OPEN c_comediens FOR 'SELECT * FROM cc_qui_a_joue_quoi WHERE spe_nom = ''' || v_spe_nom || ''' ORDER BY ' || v_tri;
              FETCH c_comediens INTO v_comedien;
              WHILE c_comediens%FOUND LOOP
                dbms_output.put_line(' - ' || v_comedien.com_nom || ' a joué ' || v_comedien.nb_joue || ' fois...');
                FETCH c_comediens INTO v_comedien;
              END LOOP;
              CLOSE c_comediens;
           END;
           
           DECLARE
              v_date  cc_representation.rep_date%TYPE;
           BEGIN
              SELECT MAX(rep_date) INTO v_date FROM cc_representation WHERE rep_date<SYSDATE AND rep_spe_no=v_spe_no;
              IF v_date IS NULL THEN
                dbms_output.put_line('Aucune représentation');
              ELSE
                dbms_output.put_line('Dernière représentation : ' || v_date);
              END IF;
           END;
           
           FETCH c_repres INTO v_spe_nom;
         END LOOP;
         CLOSE c_repres;
       END QuiPeutJouerACetteDate;
       
end pkg_cc2022_faitEnClasse;
/
