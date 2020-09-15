날짜 관련된 함수
TO_CHAR 날짜 ==> 문자
TO_DATE 문자 ==> 날짜

날짜 ==> 문자 ==> 날짜
문자 ==> 날짜 ==> 문자

SYSDATE(날짜)를 이용하여 현재 월의 1일자 날짜로 변경하기

NULL 관련 함수 - NULL과 관련된 연산의 결과는 NULL
총 4가지 존재, 다 외우진 않아도 괜찮음, 본인이 편한 함수로 하나 정해서 사용 방법을 숙지.

1. NVL(expr1, expr2)
    if(expr1 == null)
        System.out.println(expr2);
    else
        System.out.println(expr1);
        
2.NVL2(expr1, expr2, expr3)
    if(expr1 != null)
        System.out.println(expr2);
    else
        System.out.println(expr3);
        
3. NULLIF(expr1, expr2)         -- 인자 두개가 값이 같을때
    if(expr1 == expr2)
        System.out.println(NULL);
    else
        System.out.println(expr1);   
        
함수의 인자 개수가 정해지지 않고 유동적으로 변경이 가능한 인자 : 가변인자

4. caslesce(expr1, expr2, expr3 ....)    : coalesce의 인자 중 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
    if(expr1 != NULL)
        System.out.println(expr1)
    else
        coalesce(expr2, expr3 ....)
        
coalesce(null, null, 5, 4)
    ==> coalesce(null, 5, 4) 
        ==>coalesce(5, 4) 
            ==> System.out.println(5);
        
comm 컬럼이 NULL 일때 0으로 변경하여 sal 컬럼과 합계를 구한다  
SELECT empno, ename, sal, comm, 
        sal + NVL(comm, 0) nvl_sum,
        sal + NVL2(comm,comm, 0) nvl2_sum,
        NVL2(comm, sal+comm, sal) nvl2_sum2,
        NULLIF(sal, sal) nullif,
        NULLIF(sal, 5000) nullif_sal,
        sal + COALESCE(comm, 0) coalesce_sum,    --결과적으로 sal 컬럼만 나온다
        COALESCE(sal + comm, sal) coalesce_sum2 
FROM emp;

실습_ fn4] mgr컬럼의 값이 NULL일때 9999로 표현하고, NULL이 아니면 원본 값 그대로 사용
NVL, NVL2, COALESCE
SELECT empno, ename, mgr,
         NVL(mgr, 9999) mgr_n,
         NVL2(mgr, mgr, 9999) mgr_n_1,
        COALESCE(mgr, mgr, 9999) mgr_n_2  --COALESCE(mgr, 9999) 이렇게 써도 됨
        FROM emp;
        
        
SELECT userid, usernm, reg_dt,
        NVL( reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid != 'brown';    --부정형
(괄호 안에 들어가는걸)in - list : 1000
WHERE userid IN ('cony', 'sally', 'james', 'moon'); --긍정형

조건 : condition
java 조건 체크 : if, switch
 if(조건)
   실행할 문장
else if(조건)
    실행할 문장
else
    실행할 문장

SQL : CASE 절   
CASE
    WHEN 조건 THEN 반환할 문장
    WHEN 조건2 THEN 반환할 문장
    ELSE 반환할 문장
END


emp  테이블에서 job 컬럼의 값이
    'SALESMAN'이면 sal 값에 5%를 인상한 급여를 반환 sal * 1.05
    'MANAGER'이면 sal 값에 10%를 인상한 급여를 반환 sal * 1.10
    'PRESIDENT'이면 sal 값에 20%를 인상한 급여를 반환 sal * 1.20
    그밖의 직군('CLERK', 'ANALYST')은 sal 값 그대로 반환
   
CASE절을 이용 새롭게 계산한 sal_b
SMITH : 800, ALLEN : 1680
SELECT ename, job, sal, 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
        END sal_b
FROM emp;


가변인자 : 
DECODE(col(expr1, 
                search1, return1,
                search2, return2,
                search3, return3,
               [default])

첫번째 컬럼이 두번째 컬럼(search1)과 같으면 세번째 컬럼(return1)을 리턴
첫번째 컬럼이 네번째 컬럼(search2)과 같으면 다섯번째 컬럼(return2)을 리턴
첫번째 컬럼이 여섯번째 컬럼(search3)과 같으면 일곱째 컬럼(return3)을 리턴
일치하는 값이 없을 때는 default 리턴



SELECT ename, job, sal, 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
        END sal_b,
        DECODE(job, 
                    'SALESMAN', sal * 1.05,
                    'MANAGER', sal * 1.10,
                    'PRESIDENT', sal * 1.20,
                    sal) sal_decode
FROM emp;

CASE , DECODE 둘다 조건 비교시 사용
차이점 : DECODE의 경우 값 비교가 = (EQUAL)에 대해서만 가능
        복수조건은 DECODE를 중첩하여 표현
        CASE는 부등호 사용가능, 복수개의 조건 사용가능
        (CASE
            WHEN sal > 3000 AND job = 'MANAGER')

SELECT *
FROM emp;
실습 cond1]
SELECT empno, ename, 
        DECODE(deptno,
                '10', 'ACCOUNTING',
                '20', 'RESEARCH',
                '30', 'SALES',
                '40', 'OPERATIONS',
                deptno, 'DDTI') dname
FROM emp;
        
SELECT empno, ename, 
    CASE
        WHEN deptno = 10 THEN  'ACCOUNTING'
        WHEN deptno = 20 THEN  'RESEARCH'
        WHEN deptno = 30 THEN  'SALES'
        WHEN deptno = 40 THEN  'OPERATIONS'
        ELSE 'DDIT'
        END DNAME
FROM emp;

실습 cond2]
직원의 입사년도와, 올해년도의 짝수 구분을 이용해서 "올해" 건강검진 대상자인지
구하는 게 문제.

건강검진 대상 여부 : 출생년도의 짝수 구분과, 건강검진 실시년도(올해)의 짝수 구분이 같을 때
    ex: 1983년생은 홀수년도 출생이므로 2020(짝수년도)에는 건강검진 비대상
        1983년생은 홀수년도 출생이므로 2021(홀수년도)에는 건강검진 대상
        
어떤 양의 정수 x가 짝수인지 홀수인지 구별법?
짝수는 2로 나눴을 때 나머지가 0
홀수는 2로 나눴을 때 나머지가 1

나머지는 나누는 수(2)보다 항상 작다
나머지는 항상 0,1
나머지 연산 : java %, SQL : mod
        
--선생님 코드--
SELECT empno, ename, MOD( TO_CHAR(hiredate, 'YYYY'), 2) ,
                     MOD( TO_CHAR(SYSDATE, 'YYYY'), 2) ,
    CASE
        WHEN MOD( TO_CHAR(hiredate, 'YYYY'), 2) = MOD( TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
        END contact_to_doctor

FROM emp;





SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY') year,  TO_CHAR(SYSDATE, 'YYYY'),
        CASE 
            WHEN   mod( TO_CHAR(hiredate, 'YYYY'), 2) = 0 THEN 0
            WHEN  mod( TO_CHAR(hiredate, 'YYYY'), 2) = 1 THEN 1
            END xx,
            TO_CHAR(SYSDATE, 'YYYY')- TO_CHAR(hiredate, 'YYYY') aaa
FROM emp;

SELECT empno, ename, hiredate, TO_CHAR(hiredate, 'YYYY') year, TO_CHAR(SYSDATE, 'YYYY')
  FROM emp;     


실습 3]
SELECT * 
FROM users

SELECT userid, usernm, reg_dt, 
    CASE
        WHEN  MOD(TO_CHAR(reg_dt, 'YYYY'), 2) =  MOD( TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
        END contacttodoctor,
        DECODE(MOD(TO_CHAR(reg_dt, 'YYYY'), 2),             --DECODE
                   MOD( TO_CHAR(SYSDATE, 'YYYY'), 2),  '건강검진 대상자',
                    '건강검진 비대상자')contact_to_doctor2
FROM users

많이 쓰이는 함수, 잘 알아두자
(개념적으로 혼돈하지 말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리)



그룹함수  : 여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환하는 함수
오라클 제공 그룹함수 
MIN(컬럼:익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼:익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼:익스프레션) : 그룹의 평균값을 반환
SUM(컬럼:익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼 | 익스프레션 | *) : 그룹핑된 행의 개수

SELECT
FROM 테이블명
(WHERE)
GROUP BY 행을 묶을 컬럼
HAVING 그룹함수 체크조건1;

SELECT *
FROM emp
ORDER BY deptno;

그룹함수에서 많이 어려워 하는 부분
SELECT 절에 기술할 수 있는 컬럼의 구분 : 
                    GRUOP BY 절에 나오지 않은 컬럼이 SELECT 절에 나오면 에러

SELECT deptno, ename, MIN(ename),  COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY deptno, ename;
//부서번호로 묶으면 14행이 3개로 줄어든다

전체 직원(모든 행을 대상으로) 중에 가장 많은 급여를 받는 사람의 값
 : 전체 행을 대상으로 그룹핑 할 경우 GROUP BY 절을 기술하지 않는다
 
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;

SELECT  MAX(sal)
FROM emp;

전체직원중에 가장 큰 급여 값을 알수는 있지만 해당 급여를 받는 사람이 누군지는
그룹함수만 이용 해서는 구할 수가 없다
emp 테이블 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당 사원이 누구인지는 
그룹함수만 사용해서는 누군지 식별할 수 없다
    ==> 추후 진행
SELECT  MAX(sal)
FROM emp;

COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수

SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

그룹함수의 특징 : NULL값을 무시
NULL 연산의 특징 : 결과 항상 NULL이다
SELECT SUM (comm)
FROM emp;

SELECT SUM(sal + comm)
FROM emp;

그룹함수 특징2 : 그룹화 관련없는 상수들은 SELECT 절에 기술할 수 있다
SELECT deptno, SYSDATE, 'TEST', 1, COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수 특징3 : 
        SINGLE ROW 함수의 경우 WHERE 에 기술하는 것이 가능하다
        ex : SELECT * 
             FROM emp
             WHERE ename = UPPER('smith');
             
        그룹함수의 경우 WHERE에서 사용하는 것이 불가능 하다
            ==> HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수 있다
          
            그룹함수는 WHERE절에 사용 불가
            SELECT deptno, COUNT(*)
            FROM emp
            WHERE COUNT(*) >= 5
            GROUP BY deptno;

            그룹함수에 대한 행 제한은 HAVING 절에 기술    
            SELECT deptno, COUNT(*)
            FROM emp
            GROUP BY deptno
            HAVING COUNT(*) >= 5;

질문)GROUP BY 를 사용하면 WHERE 절을 사용 못하나?
GROUP BY 에 대상이 되는 행들을 제한할 때 WHERE절을 사용
    SELECT deptno, COUNT(*)
    FROM   emp
    WHERE sal > 1000
    GROUP BY deptno;

            실습 Grp 1]
            SELECT MAX(sal), MIN(sal), ROUND(AVG(sal), 2),
            SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
            FROM emp;
    
SELECT * 
FROM emp;

            실습 grp2]
            SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal), 2),
            SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
            FROM emp
            GROUP BY deptno;

** GROUP BY 절에 기술한 컬럼이 SELECT 절에 오지 않아도 실행에는 문제는 없다

            실습 grp3]
            SELECT   CASE
                     WHEN deptno = 10 THEN  'ACCOUNTING'
                     WHEN deptno = 20 THEN  'RESEARCH'
                     WHEN deptno = 30 THEN  'SALES'
                     END DNAME, 
                     MAX(sal), MIN(sal), ROUND(AVG(sal), 2),
            SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
            FROM emp
            GROUP BY deptno
            ORDER BY dname;
--선생님코드
     SELECT  DECODE( deptno , 10, 'ACCOUNTING', 20, 'RESEARCH', 30 ,  'SALES') DNAME, 
                     MAX(sal), MIN(sal), ROUND(AVG(sal), 2),
            SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
            FROM emp
            GROUP BY DECODE( deptno , 10, 'ACCOUNTING', 20, 'RESEARCH', 30 ,  'SALES') --반드시 컬럼이 필요없다 익스프레션도 가능하다
            ORDER BY dname;


            실습 grp4]
            SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, 
                    COUNT(TO_CHAR(hiredate, 'YYYYMM')) CNT
            FROM emp
            GROUP BY TO_CHAR(hiredate, 'YYYYMM');  --제대로 묶기위해 계속 표현해야 한다. 

            실습 grp5]
            SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, 
                    COUNT(TO_CHAR(hiredate, 'YYYY')) CNT
            FROM emp
            GROUP BY TO_CHAR(hiredate, 'YYYY');

            실습 grp6]
            SELECT *
            FROM dept;
            
            SELECT COUNT(*) CNT
            FROM dept;
            
            실습 grp7]
            SELECT COUNT(COUNT(deptno)) cnt
            FROM emp
            GROUP BY deptno ;

            
-------------------------------
        SELECT COUNT(deptno)
        FROM emp
        GROUP BY deptno
        HAVING deptno = 10;
---------------------------------
--JOIN

***** WHERE + JOIN SELECT SQL의 모든 것 *****
JOIN : 다른 테이블과 연결하여 데이터를 확장하는 문법
        . 컬럼을 확장
** 행을 확장 - 집합연산자(UNION, INTERSECT, MINUS)

JOIN 문법 구분
 1. ANSI - SQL
        : RDBMS 에서 사용하는 SQL 표준
        ( 표준을 잘 지킨 모든 RDBMS-MYSQL, MSSQL, POSTGRESQL... 에서 실행가능)
 2. ORACLE - SQL
        :ORACLE사만의 고유 문법 
        
회사에서 요구하는 형태로 따라가자     
7(oracle) : 3(ansi)

NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
                컬럼의 값이 같은 행들끼리 연결
    ANSI=SQL

    SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
    
    조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급
    emp, deptno (X) ==> deptno (O)
    
    컬럼명이 한쪽 테이블에만 존재할 경우 테이블 한정자를 붙이지 않아도 상관 없다.
    emp.empno (O), empno (O)
    
    SELECT  empno, deptno, dname
    FROM emp NATURAL JOIN dept;
    
    
            SELECT *
            FROM emp NATURAL JOIN dept; --deptno 컬럼이 두 테이블에 있다
                                        --공통된 컬럼이 앞으로 빠진다
              
NATURAL JOIN을 ORACLE 문법으로 
1. FROM 절에 조인할 테이블을 나열한다.
2. WHERE 절에 테이블 조인 조건을 기술한다.

컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서
오라클 입장에서는 해당 컬럼이 어떤 테이블의 컬럼인 알수가 없을 때 발생.
deptno 컬럼은 emp, dept 테이블 양쪽 모두에 존재한다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp, dept
WHERE deptno = deptno;      --에러남

인라인뷰 별칭처럼, 테이블 별칭을 부여하는게 가능
컬럼과 다르게 AS 키워드는 붙이지 않는다

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;


ANSI - SQL : JOIN WITH USING
    조인 하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때 
    하나의 컬럼으로만 조인을 하고 싶을 때 사용
SELECT * 
FROM emp JOIN dept USING (deptno);

ORACLE 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN WHIT ON - 조인 조건을 개발자가 직접 기술
           NATURAL JOIN, JOIN WHIT USING 절을 JOIN WHIT ON 절을 통해 표현 가능
           
SELECT *
FROM emp JOIN dept ON( emp.deptno = dept.deptno )
WHERE emp.deptno IN (20, 30);

oracle
SELECT *
FROM emp, dept 
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN (20, 30);

        
논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno)
--관리자 사항은 사원쪽에 있다 (?)

ORACLE
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno;


KING 의 경우 mgr 컬럼의 값이 null이기 때문에  e.mgr = m.empno 조건을 충족 시키지 못함
그래서 조인 실패해서 14건 중 13건에 데이터만 조회

2. NONEQUI JOIN : 조인 조건이 = 이 아닌 조인
SELECT * 
FROM emp, dept
WHERE emp.empno=7369
    AND emp.deptno != dept.deptno;

sal 를 이용해서 등급을 구하기

SELECT *
FROM salgrade;

SELECT *
FROM emp;

SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE emp.sal >= losal
    AND sal <= hisal;




SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;
   
   위의 SQL을 ANSI-SQL로 변경     

SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON (sal BETWEEN losal AND hisal);
   
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON(emp.sal >= losal AND sal <= hisal);
-----------------------------------------------------------------
실습 JOIN 0] - 0.4
SELECT *
FROM emp;
SELECT *
FROM dept;
실습 0]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;
]
--JOIN을 쓴 코드

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY emp.deptno;


실습0_1]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != 20 AND dept.deptno != 20; --잘못한것

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.deptno != 20 AND dept.deptno != 20
ORDER BY emp.deptno;

실습0_2]
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
ORDER BY emp.deptno;

실습0_3]
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500 AND emp.empno > 7600
ORDER BY emp.deptno;

실습0_4]
SELECT emp.empno, emp.ename, emp.sal, emp.deptno,  dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE emp.sal > 2500 AND emp.empno > 7600 AND dept.dname = 'RESEARCH';














