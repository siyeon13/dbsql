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
 
SELECT *
FROM customer;
 
SELECT p.pid, p.pnm, : cid cid, NVL(c.day, 0), NVL(c.cnt, 0) cnt
FROM  product p ,cycle c --왼쪽이 기준이 됨
WHERE p.pid = c.pid(+)
AND c.cid(+) = 1;

--실습 5 outerjoin
SELECT p.pid, p.pnm,  NVL(c.cid, 1) cid,
       cu.cnm, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p ,cycle c , customer cu
WHERE p.pid = c.pid(+)
AND c.cid(+) = 1
AND 1 = cu.cid;





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

전체 직원의 급여 평균보다 높은 급여를 받는 사원들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);

본인이 속한 부서의 급여 평균보다 높은 급여를 받는 사람들을 조회
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
                FROM emp
                WHERE deptno = e.deptno)

sub4]
테스트용 데이터 추가
DESC dept
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

DELETE dept VALUES (99, 'ddit', 'daejeon');

1. emp 테이블에 등록된 사원들이 속한 부서 번호 확인
SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (10, 20 ,30);

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);

실습 sub5 ]
1번 고객이 먹지 않는 제품 정보를 조회        
SELECT *
FROM product; 
1번 고객이 먹는 제품은?
SELECT *
FROM cycle
WHERE cid = 1;         
==> 답
 SELECT * 
 FROM  product 
 WHERE pid NOT IN (SELECT pid 
                    FROM cycle 
                    WHERE cid = 1);
                    
 실습 sub6 ]                   
1번 고객이 애음하는 제품 중 2번 고객도 애음하는 제품의 애음 정보 조회
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
           FROM cycle
           WHERE cid = 2);
           
--내가 한거              
SELECT *
FROM cycle
WHERE pid IN (SELECT pid
           FROM cycle
           WHERE cid = 1 OR cid = 2);                    
                    
실습 7] 과제


2항 연산자 : 1 + 2
3항 연산자 : int a + b == c ? 1 : 2;

EXISTS 연산자 : 조건을 만족하는 서브 쿼리의 행이 존재하면 TRUE
--매니저가 존재하는 사원 정보 조회
SELECT *
FROM emp e
WHERE EXISTS ( SELECT *
               FROM emp m
               WHERE e.mgr = m.empno);

실습 8--

               
실습 9-- 4개의 제품 중 1번 고객이 먹는 제품만 조회
--1
SELECT *
FROM cycle;

SELECT * 
FROM product;
--2   
SELECT pid
FROM cycle
WHERE cid = 1;
               
--3
SELECT *
FROM product
WHERE EXISTS ( SELECT 'X'
               FROM cycle
               WHERE cycle.pid = product.pid
               AND  cycle.cid = 1);
1) 선생님
SELECT *
FROM cycle
WHERE cid =1
AND pid = 400;
2)
SELECT * 
FROM product
WHERE  EXISTS (SELECT *
               FROM cycle
               WHERE cid =1
               AND pid = product.pid);

실습 10
**1번 고객이 먹지 않는 제품 정보 조회
SELECT * 
FROM product
WHERE NOT EXISTS (SELECT *
                 FROM cycle
                 WHERE cid =1
                 AND pid = product.pid);
                 
집합연산자 : 알아두자
수학의 집합 연산
A = { 1, 3, 5 }
B = { 1, 4, 5 }

합집합 : A U B = { 1, 3, 4, 5 }  A U B == B U A (교환법칙 성립)
교집합 : A ^ B = { 1, 5 }        A ^ B == B ^ A (교환법칙 성립)
차집합 : A - B = { 3 }           A - B != B - A (교환법칙 성립하지 않음)
        B - A = { 4 }
        
SQL에서의 집합 연산자
합집합 : UNION     : 수학적 합집합과 개념이 동일(중복을 허용하지 않음)
                    중복을 체크 ==> 두 집합에서 중복된 값을 확인 ==> 연산이 느림
        UNION ALL : 수학적 합집합 개념을 떠나 두개의 집합을 단순히 합친다
                    (중복 데이터 존재 가능)
                    중복 체크 없음 ==> 두 집합에서 중복된 값 확인 없음 ==> 연산이 빠름
                    ** 개발자가 두개의 집합에 중복되는 데이터가 없다는 것을 알 수 있는
                    상황이라면 UNION 연산자를 사용하는 것보다 UNION ALL 을 사용하여
                    (오라클이 하는)연산을 절약할 수 있다.
        INTERSECT : 수학적 교집합 개념과 동일
        MINUS : 수학적 차집합 개념과 동일
 
 위아래 집합이 동일하기 때문에 합집합을 하더라도 행이 추가되진 않는다                
 SELECT empno, ename
 FROM emp
 WHERE deptno = 10
 UNION
 SELECT empno, ename
 FROM emp
 WHERE deptno = 10;             
  
 위아래 집합에서 7369번 사번은 중복되므로 한번만 나오게 된다 : 전체 행은 3건       
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7566)
 UNION
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7782);
             
 UNION ALL 연산자는 중복제거 단계가 없다. 총 데이터 4개의 행                
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7566)
 UNION ALL
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7782);                 
                 
 두집합의 공통된 부분은 7369행 밖에 없음 : 총 데이터 1명
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7566)
 INTERSECT
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7782);      

 윗쪽 집합에서 아래쪽 집합의 행을 제거하고 남은 행 : 1개의 행(7369)
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7566)
 MINUS
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7782);    


 집합연산자 특징
 1. 컬럼명은 첫번째 집합의 컬럼명을 따라간다.
 2. ORDER BY 절은 마지막 집합에 적용 한다.
    마지막 sql이 아닌 SQL에서 정렬을 사용하고 싶은 경우 INLINE-VIEW를 활용
    UNION ALL의 경우 위, 아래 집합을 이어 주기 때문에 집합의 순서를 그대로 유지
    하기 때문에 요구사항에 따라 정렬된 데이터의 집합이 필요하다면 해당 방법을 고려
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7566)
 UNION ALL
 SELECT empno, ename
 FROM emp
 WHERE empno IN ( 7369, 7782)
 ORDER BY ename;  








                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 