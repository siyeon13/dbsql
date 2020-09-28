pc21.v_emp => v_emp

SELECT *
FROM pc21.v_emp;

CREATE SYNONYM v_emp FOR pc21.v_emp;

SELECT *
FROM v_emp;