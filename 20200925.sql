REPORT GROUP FUNCTION
GROUP BY 의 확장 : SUBGROUP을 자동으로 생성하여 하나의 결과로 합쳐준다
1. ROLLUP (col1, col2...)
    - 기술된 컬럼을 오른쪽에서 부터 지워 나가며 서브 그룹을 생성
    
2. GROUPINT SETS ( (col1, col2) , col3)
    - , 단위로 기술된 서브 그룹을 생성
    
3. CUBE(col1, col2....)
    - 컬럼의 순서는 지키되, 가능한 모든 조합을 생성한다
GROUP BY CUBE(job, deptno)      ==> 4개          (경우에 수가 많아서 잘 쓰지는 않다)
    job     deptno
    0          0    ==> GROUP BY job, deptno
    0          x    ==> GROUP BY job
    x          0    ==> GROUP BY deptno (ROLLUP 에는 없던 서브 그룹)
    x          x    ==> GROUP BY 전체
    
GROUP BY ROLLUP (job, deptno)   ==> 3개


SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 가능한 모든 조합으로 서브 그룹을 생성하기 때문에
2의 기술한 컬럼개수 승 만큼의 서브 그룹이 생성된다.
CUBE(col1, col2) : 4
CUBE(col1, col2, col3) : 8가지 나온다.
CUBE(col1, col2, col3, col4) : 16

REPORT GROUP FUNCTION 조합
GROUP BY job, ROLLUP(deptno), CUBE(mgr)
      (디폴트) deptno           mgr
              전체             전체
              (두가지)         (두가지)

        job, deptno,mgr
        job,   deptno
        job,   mgr
        job,   전체
              
SELECT job, deptno, mgr ,SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

상호 연관 서브 쿼리를 이용한 업데이트
1. EMP_TEST 테이블 삭제
2. EMP테이블을 사용하여 EMP_TEST 테이블 생성(모든 컬럼, 모든 데이터)
3.EMP_TEST테이블에는 DNAME 컬럼을 추가(VARCHAR2(14) )
4.상호 연관 서브쿼리를 이용하여 EMP_TEST테이블의 DNAME 컬럼을 DEPT을 이용하여 UPDATE

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14) );

SELECT * 
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno);
--자신의 컬럼값을 참조를 해서 dname에 값 넣어주기

실습 1 서브쿼리 sub_a2]
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT * 
FROM dept_test;

DESC emp_test;

ALTER TABLE dept_test ADD (empcnt NUMBER(2));

UPDATE dept_test SET empcnt =
(SELECT COUNT(*) empcnt FROM emp WHERE deptno = dept_test.deptno);

**10번인 사람들 추출하기
SELECT COUNT(*) CNT
FROM emp
WHERE deptno = 30;

COMMIT;

실습 2 서브쿼리 sub_a2]
INSERT INTO dept_test (deptno, dname, loc) VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98, 'it2', 'daejeon');
COMMIT;

SELECT deptno, dname
FROM dept_test;

부서에 속한 직원이 없는 부서를 삭제하는 쿼리를 작성하세요
SELECT deptno, dname
FROM dept_test;

DELETE dept_test WHERE deptno NOT IN (SELECT deptno 
                               FROM emp
                               WHERE deptno = dept_test.deptno);

SELECT *
FROM dept_test;
ROLLBACK;
(선생님)
DELETE dept_test 
WHERE 0 = (SELECT COUNT(*)
           FROM emp
           WHERE deptno = dept_test.deptno);
--직원수가 0인 사람을 지우기

DELETE dept_test 
WHERE NOT EXISTS (SELECT 'X' 
              FROM emp
              WHERE deptno = dept_test.deptno);
              
실습 3 서브쿼리 sub_a3]
과제sub 3]
SELECT *
FROM emp_test;

SELECT sal+200
FROM emp_test
WHERE sal < (SELECT AVG(sal)
            FROM emp_test);
            
UPDATE emp_test a SET sal = sal+200 WHERE sal < (SELECT AVG(sal)
                                         FROM emp_test b
                                         WHERE a.deptno = b.deptno);


ROLLBACK;
COMMIT;





달력만들기 : 행을 열로 만들기 - 레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 (수업시간에는 '202009' 문자열을 사용)

*'202009' ==> 30*
*'202008' ==> 31*
SELECT TO_CHAR(LAST_DAY(TO_DATE('202002' ,'YYYYMM')), 'DD')
FROM dual;

SELECT TO_DATE('202002', 'YYYYMM') + LEVEL-1 DAY,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1 , 'D') D
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002' ,'YYYYMM')), 'DD');



SELECT  MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon, 
        MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed, 
        MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri, 
        MIN(DECODE(d, 7, day)) sat
FROM 
(SELECT TO_DATE('202002', 'YYYYMM') + LEVEL-1 DAY,
         TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1 , 'D') D ,
         TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL-1 , 'IW') IW 
FROM dual 
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002' ,'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw) 
ORDER BY DECODE(d, 1, iw+1, iw) ;


SELECT DUAL.*,LEVEL  
FROM dual
CONNECT BY LEVEL <= 30;


--달력과 같게 만들려면 일요일의 주차를 1 더한다


SELECT DECODE(d, 1, iw+1, iw),
        MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon, 
        MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed, 
        MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri, 
        MIN(DECODE(d, 7, day)) sat
FROM 
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 DAY,
         TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 , 'D') D ,
         TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL-1 , 'IW') IW 
FROM dual 
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm ,'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw) 
ORDER BY DECODE(d, 1, iw+1, iw) ;


SELECT  TO_CHAR(TO_DATE('20191230', 'YYYYMMDD'), 'iw'),
        TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'iw'),
        TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'iw')
FROM dual;



SELECT SYSDATE +  LEVEL, LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

실습 calendar1]
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT * 
FROM sales;



SELECT  NVL(MIN(DECODE(mm, '01', sales)), 0) jan , 
        NVL(MIN(DECODE(mm, '02', sales)), 0) feb,
        NVL(MIN(DECODE(mm, '03', sales)), 0) mar,  
        NVL(MIN(DECODE(mm, '04', sales)), 0) apr,
        NVL(MIN(DECODE(mm, '05', sales)), 0) may,  
        NVL(MIN(DECODE(mm, '06', sales)), 0) jun
FROM
(SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(dt, 'mm'));


--dept_h.sql
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

PRIOR : 첫번째 행

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm  deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;







