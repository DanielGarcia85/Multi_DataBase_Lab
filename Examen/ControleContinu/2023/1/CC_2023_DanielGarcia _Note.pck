create or replace package cc_2023_DanielGarcia is

  PROCEDURE afficherXXX(i_xxx IN xxx.xxx%TYPE, i_xxx IN VARCHAR2);

end cc_2023_DanielGarcia;
/
create or replace package body cc_2023_DanielGarcia is

  PROCEDURE afficherXXX(i_xxx xxx.xxx%TYPE, i_xxx VARCHAR2) IS
    
    CURSOR crs_xxx IS SELECT xxx;
    
    crs_xxx SYS_REFCURSOR;
    v_rqt_sql VARCHAR2(200);
    
    TYPE TYPE_XXX IS RECORD(xxx xxx.xxx%TYPE, xxx xxx.xxxb%TYPE);
    v_xxx TYPE_XXX;
    
    err_xxx EXCEPTION;
    err_yyy EXCEPTION;
    PRAGMA EXCEPTION_INIT(err_yyy, -06550);
    
  BEGIN
    
    FOR r_xx IN crs_xx LOOP
    END LOOP;
    
    v_rqt_sql := 'xxx';
    OPEN crs_xxx FOR v_rqt_sql;
    FETCH crs_xx INTO v_xxx;
    
    IF crs_xxx%NOTFOUND THEN RAISE err_xxx END IF;
    
    WHILE crs_xxx%FOUND LOOP
      FETCH crs_xx INTO v_xxx;
    END LOOP;
    CLOSE crs_xxx;
    
    dbms_output.new_line;
    
  EXCEPTION
    
    WHEN err_xxx THEN dbms_output.put_line('xxx');dbms_output.new_line;
    WHEN err_yyy THEN dbms_output.put_line('xxx');dbms_output.new_line;
    
  END afficherXXX;

end cc_2023_DanielGarcia;
/
