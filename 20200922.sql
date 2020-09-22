VIEW : VIEW는 쿼리이다 (VIEW 테이블은 잘못된 표현)
 . 물리적인 데이터를 갖고 있지 않고, 
   논리적인 데이터 정의 집합이다(SELECT 쿼리)
 . VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과에도 영향을 미친다.
 
 VIEW 를 사용하는 사례
 1. 데이터 노출을 방지
 (emp 테이블의 sal, comm 을 제외하고 view를 생성, HR계정에게
 view를 조회할 수 있는 권한을 부여.
 HR 계정에서 emp테이블을 직접 조회하지 못하지만 v_emp는 가능
    ==> V_EMP에는 sal, comm컬럼 없기 때문에 급여관련 정보를 감출 수 있었다.
    
2. 자주 사용되는 쿼리를 view 만들어서 재사용
 ex : emp 테이블은 dept 테이블이랑 조인되서 사용되는 경우가 많음
 view를 만들지 않을 경우 매번 조인 쿼리를 작성해야하나 view로만 돌면 재사용이 가능
 
 3. 쿼리가 간단해진다
 
 emp테이블과 dept 테이블은 deptno가 같은 조건으로 조인한 결과를 v_emp_dept 이름으로 view 생성
 CREATE OR REPLACE VIEW v_emp_dept AS
 SELECT emp.*, dept.dname, dept.loc
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
VIEW  삭제
 DROP VIEW 뷰이름;
 DROP VIEW v_emp_dept;
 
 
 CREATE VIEW v_emp_cnt AS
 SELECT deptno, COUNT(*) cdt
 FROM emp
 GROUP BY deptno;
 
 SELECT *
 FROM v_emp_cnt
 WHERE deptno = 10;
 
 ROLLBACK:
 
 sequnce : 중복되지 않는 정수값을 만들어 재는 오라클 객체
    HAVA : UUID 클래스를 통해 중복되지 않은 문자열을 생성 할 수 있다.
    
    SQL_사용할테이블이름;
문법 : CREATE SEQUENCE 시퀀스 이름;    
CREATE SEQUENCE SEQ_emp;

사용방법 : 함수를 생각하자
함수 테스트 : DUAL
시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환
시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있다
                      nextval 함수를 통해 얻어진 값을 반환
                      
SELECT seq_emp.nextval
FROM dual;

시퀀스는 중복을 허용하지 않는다.
 
SELECT seq_emp.currval
FROM dual;
--nextval 함수 마지막 실행 결과를 기억함

사용예
INSERT INTO emp (empno, ename, hiredate)
        VALUES (seq_emp.nextval, 'brown', sysdate);
        
SELECT *
FROM emp;

15101001 : 앞 두자리 : 회사가 세워진 후 지난 년도
           다음 네자리 : 입사 월 , 입사 10월 10일 입사
           마지막 두자리 : 01 : 입사일자에 입사한 순번

의미가 있는 값에 대해서는 시퀀스만 갖고는 만들 수 없다.
시퀀스를 통해서는 중복되지 않는 값을 생성 할 수 있다.
 
시퀀스는 롤백을 하더라도 읽은 값이 복원되지 않는다.


INDEX : TABLE의 일부 컬럼을 기준으로 미리 정렬해둔 객체
ROWID : 테이블에 저장된 행의 위치를 나타내는 값

SELECT ROWID, empno, ename
FROM emp;

만약 ROWID를 알 수만 있으면 해당 테이블의 모든 데이터를 뒤지지 않아도 
해당 행에 바로 접근을 할 수가 있다

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ROWID ='AAAE5hAAFAAAACNAAB';
 
SELECT *
FROM TABLE(dbms_xplan.display);


BLOCK : 오라클의 기본 입출력 단위
BLOCK의 크기는 데이터베이스 생성시 결정, 기본값 8x byte
DESC emp;
emp 테이블 한행흔 최대 54 byte
block 하나에는 emp 테이블을 8000/54 = 160행이 들어갈 수 있음

사용자가 한행을 읽어도 해당 행이 담겨져 있는 block을 전체로 읽는다.
 
 SELECT *
 FROM user_constraints
 WHERE table_name = 'EMP';
 
 EMP 테이블의 EMPNO 컬럼에 PRIMARY KEY 추가
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
 
 PRIMARY KEY(UNIQUE + NOT NULL), UNIQUE 제약을 생성하면 해당 컬럼으로 인덱스를 생성한다
 ==>인덱스가 있으면 값을 빠르게 찾을 수 있다
    해당 컬럼에 중복된 값을 빠르게 찾기 위한 제한사항
 
 SELECT empno ,ROWID
 FROM emp
 ORDER BY empno;
 
 0. 시나리오
 테이블만 있는 경우 (제약조건, 인덱스가 없는 경우)
 SELECT *
 FROM emp
 WHERE empno = 7782;
 ==> 테이블에는 순서가 없기 때문에 emp 테이블의 14건의 데이터를 모두 뒤져보고
 empno값이  7782인 한건에 대해서만 사용자에게 반환을 한다
 
 시나리오1.
 emp 테이블의 empno 컬럼에 PK_EMP 유니크 인덱스가 생성된 경우
 (우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY 제약조건에 의해 자동으로 생성 됨)

 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE(dbms_xplan.display);
 
 시나리오 2.
 emp 테이블의 empno 컬럼에 PRIMARY KEY 제약조건이 걸려 있는 경우
 
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;
 
SELECT *
FROM TABLE(dbms_xㅕplan.display); 
 
 
 
UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 값을 허용하지 않는 인덱스 (emp.empno)
NUN_UNIQUE 인덱스 : 인덱스 구성 컬럼의 중복 값을 허용하는 인덱스  {emp.deptno, emp.job)

 시나리오 3.
 emp테이블의 empno컬럼에 non-unique 인덱스가 있는 경우
ALTER TABLE emp DROP CONSTRAINT fk_emp_emp; --어제 만든 외래키 지움
ALTER TABLE emp DROP CONSTRAINT pk_emp;
IDX_테이블명_U_01
IDX_테이블명_N_02
CREATE INDEX IDX_emp_N_01 ON emp (empno);


 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = 7782
 
 SELECT *
 FROM TABLE(dbms_xplan.display);
 
 시나리오4
 emp 테이블의 job 컬럼으로 non_unique 인덱스를 생성한 경우
 CREATE INDEX idx_emp_n_02 ON EMP (job);
 
 emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
 EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

 SELECT *
 FROM TABLE(dbms_xplan.display);

 
 
 시나리오5
 emp 테이블의 job 컬럼으로 non_unique 인덱스를 생성한 경우
 CREATE INDEX idx_emp_n_02 ON EMP (job);
 
 emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job



EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
 SELECT *
 FROM TABLE(dbms_xplan.display);

 
  시나리오6
CREATE INDEX idx_emp_n_03 ON emp (job, ename);
 
emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_03 : job, ename 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
 
SELECT *
FROM TABLE(dbms_xplan.display);
 
SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;
 


  시나리오7
DROP INDEX idx_emp_n_03;
CREATE INDEX idx_emp_n_04 ON emp (ename, job);
 
emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_04 :  ename, job

SELECT ename, job, ROWID
FROM emp
ORDER BY job, ename;
 
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
 
SELECT *
FROM TABLE(dbms_xplan.display);
 
 
 시나리오8

CREATE INDEX idx_emp_n_04 ON emp (ename, job);
 
emp 테이블에는 현재 인덱스가 3개 존재
emp 테이블의 empno 컬럼에 UNIQUE 인덱스 생성
dept 테이블의 deptno 컬럼에 UNIQUE 인덱스 생성

DROP INDEX idx_emp_n_01;


--pk 만드는 명령어
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

pk_emp : empno
idx_emp_n_02 : job
idx_emp_n_04 :  ename, job

dept 테이블에는 현재 인덱스가 1개 존재
pk_dept : deptno;

4       2     8
emp => dept
4       2     8 
dept => emp

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
 AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);


SELECT *
FROM user_CONSTRAINTS
WHERE table_name IN ('EMP','DEPT');







idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_04 :  ename, job
dept 테이블의 deptno 컬럼에 UNIQUE 인덱스 생성 


SELECT ename, job, ROWID
FROM emp
ORDER BY job, ename;
 
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';
 
SELECT *
FROM TABLE(dbms_xplan.display);
 