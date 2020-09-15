cid : customer id
cnm : customer name

SELECT *
FROM customer;

product : 제품
pid : product id : 제품 번호
pnm : product name : 제품 이름
SELECT *
FROM product;


cycle : 고객애음주기
cid : customer id 고객 id
pid : product id 제품 id
day : 1~7(일~토)
cnt : count, 수량
SELECT *
FROM cycle;

[실습 4 JOIN]
ANSI-SQL
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid)
WHERE customer.cnm = 'brown' OR customer.cnm = 'sally';

oracle
SELECT customer.cid, cnm, cycle.pid, cycle.day, cycle.cnt     --그냥 *만 하면 cid가 두번 나옴
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND  customer.cnm IN ('brown' , 'sally');
--natural join
SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt    
FROM customer NATURAL JOIN cycle
WHERE customer.cnm IN ('brown' , 'sally');



[실습 5 JOIN]
SELECT a.cid, a.cnm, a.pid, product.pnm ,a.day, a.cnt 
FROM
(SELECT customer.cid, cnm, cycle.pid, cycle.day, cycle.cnt     
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND  customer.cnm IN ('brown' , 'sally')) a, product;
SQL : 실행에 대한 순서가 없다
        조인할 테이블에 대해서 FROM 절에 기술한 순으로
        테이블을 읽지 않음.
    FROM customer, cycle, product ==> 오라클에서는 product 테이블부터 읽을 수도 있다.
    
EXPLAIN PLAN FOR   
--제대로 작성한 쿼리문 실습5
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt     
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND  customer.cnm IN ('brown' , 'sally');
    
    --실행계획--
SELECT *
FROM TABLE(dbms_xplan.display);
    
[실습 5 ANSI]
cycle - customer : cid고객번호
cycle - product : pid 제품번호

SELECT c.cid, m.cnm, c.pid, p.pnm, c.day, c.cnt
FROM cycle c JOIN customer m ON (c.cid = m.cid)
             JOIN product p ON (c.pid = p.pid)
WHERE m.cnm IN ('brown', 'sally');
    
실습 6-13 과제
[실습 6 JOIN]
SELECT c.cid, m.cnm, c.pid, p.pnm, sum(c.cnt)
FROM cycle c JOIN customer m ON (c.cid = m.cid)
            JOIN product p ON (c.pid = p.pid)
GROUP BY c.cid, m.cnm, c.pid, p.pnm, c.cnt ;
--제품명에 대해 총 합한 개수를 구할려면 그룹함수를 이용해서 구한다.
--그룹으로 묶을 컬럼은 모두 묶어야 한다

[실습 7 JOIN]
SELECT c.pid, p.pnm, sum(c.cnt)
FROM cycle c JOIN product p ON ( c.pid = p.pid )
GROUP BY c.pid, p.pnm;


[실습 8 JOIN]
SELECT *
FROM regions;
SELECT r.region_id, r.region_name, c.country_name
FROM regions r JOIN countries c ON ( r.region_id =  c.region_id);

















OUTER JOIN : 자주 쓰이지는 않지만 중요
JOIN 구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부 
        : INNER JOIN - 조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는
                       표시

사번, 사원의 이름, 관리자 사번, 관리자 이름
KING(PRESIDENT)의 경우 MGR 컬럼의 값이 NULL 이기 때문에
조인에 실패. ==> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI-SQL
--LEFT
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno);
--조인에 실패해도 왼쪽에 있는 값은 나온다.
--RIGHT
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON ( e.mgr = m.empno);

ORACLE-SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인다
             ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다
             WHERE절 연결 조건에 적용
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m 
WHERE  e.mgr = m.empno(+);



행에 대한 제한 조건 기술시 WHERE절에 기술 했을 때와 ON 절에 기술 했을 때
결과가 다르다.

사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다
SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno )
WHERE e.deptno = 10;

SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE e.deptno = 10;
==> KING 이 빠짐




SELECT e.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);
UNION
SELECT e.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);
MINUS
SELECT e.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);
--UNION 합집합 중복된거 빠진다
A = {1, 3, 5}, B = {1, 4, 5}
A U B = {1, 3, 4, 5}



SELECT e.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);
UNION
SELECT e.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);
INTERSECT               -- 위의 합집합 결과와 아래 결과가 동일
SELECT e.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

실습 OUTERJOIN 1]
SELECT *
FROM prod;
SELECT *
FROM buyprod;

SELECT *
FROM buyprod
WHERE BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');




SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id 
AND b.BUY_DATE(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

ANSI
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON (b.buy_prod = p.prod_id AND b.BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD'));


SELECT y.pid, p.pnm, sum(y.cnt) cnt
FROM cycle y JOIN customer c ON ( y.cid = c.cid)
             JOIN product p ON  ( y.pid = p.pid)
GROUP BY y.pid, p.pnm, y.cnt

--DB 시험 오답    
SELECT  'TEST1' || dummy
FROM dual;

SELECT *
FROM emp;

SELECT CONCAT(CONCAT('Hello' , ','), 'World')
FROM dual;

--실습 2 OUTERJOIN2
SELECT  b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON (b.buy_prod = p.prod_id AND b.BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

--실습2-3
SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD') buy_date, 
b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty, 0)
FROM buyprod b , prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.BUY_DATE(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD'));

--실습4 outerjoin
SELECT * 
FROM cycle;

SELECT *
FROM product;

SELECT p.pid, p.pnm, : cid cid, NVL(c.day, 0), NVL(c.cnt, 0) cnt
FROM  product p ,cycle c --왼쪽이 기준이 됨
WHERE p.pid = c.pid(+)
AND c.cid(+) = 1;

INNER JOIN : 조인이 성공하는 데이터만 조회가 되는 조인 방식
OUTER JOIN : 조인에 실패해도 기준으로 정한 테이블의 컬럼은 조회가 되는 조인 방식

EMP 테이블의 행 건수 (14) * DEPT 테이블의 행 건수 (4) = 56건
SELECT *
FROM emp, dept;

SELECT * 
FROM customer;
SELECT * 
FROM product;
CROSS JOIN 1]
오라클
SELECT *
FROM customer, product;

안시
SELECT *
FROM customer CROSS JOIN product;

SQL 활용에 있어서 매우 중요
서브쿼리 : 쿼리안에서 실행되는 쿼리
1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
  1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
  1.2 FROM : 인라인 뷰(INLINE-VIEW)
  1.3 WHERE : 서브쿼리 (SUB QUERY)
                            (행1, 행 여러개), (컬럼1, 컬럼 여러개)
2.서브쿼리 분류 - 서브쿼리가 반환하는 행, 컬럼의 개수의 따른 분류
(행1, 행 여러개), (컬럼1, 컬럼 여러개) : 
(행, 컬럼) : 4가지
  2.1 단일행, 단일 컬럼
  2.2 단일행, 복수 컬럼    ==> X
  2.3 복수행, 단일 컬럼
  2.4 복수행, 복수 컬럼

3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류
  3.1 상호 연관 서브 쿼리 (CORELATED SUB QUERY)
    - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
  3.2 비상호 연관 서브 쿼리 (NON-CORELATED SUB QUERY)
    - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우
    
SMITH가 속한 부서에 속한 사원들은 누가 있을까?
1. SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해 있는 사원들 구하기

1. SELECT deptno
   FROM emp
   WHERE ename = 'SMITH';
2. SELECT *
   FROM emp
   WHERE deptno = 20;

==> 서브쿼리를 이용하여 하나로 합칠 수가 있다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태

서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일 컬럼과 = 비교 하는 경우 ==> X 
SELECT *
FROM emp
WHERE deptno = (SELECT deptno, ename
                FROM emp
                WHERE ename = 'SMITH');

서브쿼리가 여러개의 행, 단일 컬럼을 조회하는 경우
1. 사용되는 위치 : WHERE - 서브쿼리
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일 컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무 : 비상호연관 서브쿼리
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                OR ename = 'ALLEN');       

서브쿼리 1] 평균 급여보다 높은 급여를 받는 사원의 수 구하기
1. 평균 급여 구하기
2. 1에서 구한 값보다 sal 값이 큰 사원들의 수 카운트 하기

14사원의 평균 급여 : 2073
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
서브쿼리 2            
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

서브쿼리 3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                OR ename = 'WARD');   --IN 연산자를 안쓰고 = 를 쓰면 에러가 난다
                    --여러 값이 나와서 IN 을 사용
                    
                    
복수행 연산자 : IN(중요), ANY, ALL ( 빈도 떨어진다)                    
SELECT *
FROM emp
WHERE SAL < ANY  (SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH','WARD'));  
SAL 컬럼의 값이 800이나, 1250 보다 작은 사원
==> SAL 컬럼의 값이 1250보다 작은 사원

SELECT *
FROM emp
WHERE SAL > ALL  (SELECT sal
                  FROM emp
                  WHERE ename IN ('SMITH','WARD'));  
SAL 컬럼의 값이 800보다 크면서 1250보다 큰 사원
==> SAL 컬럼의 값이 1250 보다 큰 사원


복습
NOT IN 연산자와 NULL

관리자가 아닌 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);

pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회할때 하용한다
                AND 논리연산자와 결과 값이 다를 수 있다. (아래 예시 참조)
서브쿼리 : 복수행, 복수컬럼
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));


mgr 7698, 7839
deptno 30, 10
mgr, deptno => (7698,30), (7698,10), (7839, 30), (7839, 10)
                (7698,30)                          (7839,10) 


SCALAR SUBQUERY : SELECT 절에 기술된 서브쿼리
                하나의 컬럼
*** 스칼라 서브 쿼리는 ☆하나의 행, 하나의 컬럼★을 조회하는 쿼리 이어야한다
SELECT dummy, (SELECT SYSDATE, 'TEST' --TEST 지워야함
               FROM dual)
FROM dual;

스칼라 서브쿼리가 복수개의 행(4개), 단일 컬럼을 조회 ==> 에러
SELECT empno, ename, deptno, (SELECT dname FROM dept)
FROM emp;

emp 테이블과 스칼라 서브 쿼리를 이용하여 부서명 가져오기
기존 : emp 테이블과 dept 테이블을 조인하여 컬럼을 확장

SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE deptno = emp.deptno)
FROM emp;

상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리
                - 서브쿼리만 단독으로 실행하는 것이 불가능 하다
                - 메인쿼리와 서브 쿼리의 실행 순서가 정해져 있다
                    메인쿼리가 항상 먼저 실행된다
비상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용하지 않은 서브쿼리
                - 서브쿼리만 단독으로 실행하는 것이 가능하다
                - 메인 쿼리와 서브 쿼리의 실행 순서가 정해져 있지 않다
                     메인 => 서브, 서브 => 메인 둘다 가능
 EXPLAIN PLAN FOR                    
 SELECT *
 FROM dept
 WHERE deptno IN (SELECT deptno
                    FROM emp);



SELECT dname
FROM dept
WHERE dept = 30;









                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
