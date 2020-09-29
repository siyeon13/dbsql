START WITH : 계층쿼리의 시작 점(행), 여러개의 행을 조회하는 조건이 들어갈 수도 있다
             START WITH절에 의해 선택된 행이 여러개이면, 순차적으로 진행한다
             
CONNECT BY : 행과 행을 연결할 조건을 기술

PRIOR : 현재 읽은 행을 지칭

**PRIOR 키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다
CONNECT BY PRIOR deptcd = p+deptcd;
CONNECT BY p_deptcd = PRIOR deptcd;

**연결 조건이 두개 이상일 때
CONNECT BY PRIOR p = q AND PRIOR a = b;



SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm  deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;

SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm  deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY p_deptcd = PRIOR deptcd;


계층쿼리 - 상향식
디자인팀(dept0_00_0)부터 시작하여 자신의 상위 부서로 연결하는 쿼리

계층쿼리 실습 h_3
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


계층쿼리 실습 h_4
SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*3) || s_id s_id, value, LEVEL, PS_ID
FROM h_sum
START WITH s_id ='0'
CONNECT BY PRIOR S_ID = PS_ID;


pruning branch : 가지치기
SELECT 쿼리 처음 배울 때, 설명해준 SQL 구문 실행순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY

SELECT 쿼리에 START WITH, CONNECT BY 절이 있을 경우
FROM -> START WITH, CONNECT BY -> WHERE ....

하향식 쿼리로 데이터 조회
SELECT deptcd, LPAD(' ' , (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptcd != 'dept0_01';
현재 읽을 행의 dept_cd 컬럼값이 'dept_01'이 아닐때 연결 하겠다

==> xx회사 밑에는 디자인부, 정보기획부, 정보시스템부 3개의 부가 있는데
    그중에서 정보기획부를 제외한 2개 부서에 대해서만 연결하겠다

행 제한 조건을 where 절에 기술 했을 경우
FROM -> START WITH -> WHERE 절 순으로 실행 되기 때문에
1. 계층 탐색을 전부 완료한 후
2. WHERE 절에 해당하는 행만 데이터를 제외한다

SELECT deptcd, LPAD(' ' , (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
WHERE deptcd != 'dept0_01'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


계층쿼리 특수함수(오라클 사용자에게는 중요한 함수)
CONNECT_BY_ROOT(col) : 최상위 행의 컬럼 값 조회
SYS_CONNECT_BY_PATH(col, 구분자) : 계층 순회 경로를 표현 
CONNECT_BY_ISLEAF : 해당 행이 leaf node(자식이 없는 노드)인지 여부를 반환
`````               (1 : leaf node, 0 : no leaf node)


SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,
        SYS_CONNECT_BY_PATH(deptnm, '-') scbp,
        CONNECT_BY_ISLEAF CBI
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


왼쪽에 있는 - 지워주는 LTRIM
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') scbp
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


CONNECT BY LEVEL 계층 쿼리 : CROSS JOIN 과 유사
연결가능한 모든 행에 대해 계층으로 연결

dual 테이블에는 행이 하나

SELECT dummy, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(dummy, '-'), '-') scbp
from dual
CONNECT BY LEVEL <= 10;

---------------------------------------------------------------------------------
실습 H6]
SELECT *
FROM board_test;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq IS null       --seq IN (1,2,4)
CONNECT BY PRIOR seq = parent_seq;

실습 H7-H8]
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH  parent_seq IS null 
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;
SIBLINGS : 자식 노드도 맞게 정리된다 [H8]

1. CONNECT_BY_ROOT를 활용한 그룹번호 생성
실습 H9]
SELECT *
FROM
(SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title, CONNECT_BY_ROOT(seq) gn
FROM board_test
START WITH  parent_seq IS null 
CONNECT BY PRIOR seq = parent_seq)
ORDER BY gn DESC, seq ASC;

2. gn (NUMBER) 컬럼을 테이블에 추가
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE  board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE  board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE  board_test SET gn = 4
WHERE seq IN (1, 2, 3, 9);

COMMIT;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH  parent_seq IS null 
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;


SELECT *
FROM board_test;


분석함수, 윈도우 함수

SELECT empno ,ename, sal
FROM emp
WHERE sal = (SELECT MAX(sal)
            FROM emp);

sql의 단점 : 행간 연산이 부족 ==> 해당 부분을 보온 해주는 것이 분석함수(윈도우 함수)


실습 ana0] 부서별 급여 랭크

SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

분석함수를 사용하지 않고도 위와 동일한 결과를 만들어 내는 것이 가능
(*** 분석함수가 모드 DBMS에서 제공을 하지는 않음)
SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) ) a,

(SELECT deptno, lv, ROWNUM rn
FROM 
    (SELECT a.deptno, b.lv
    FROM 
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a, 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) b
    WHERE a.cnt >= b.lv
    ORDER BY a.deptno, b.lv )) b
WHERE a.rn = b.rn;


분석함수/윈도우 함수 문법
SELECT 윈도함수이름([인자]) OVER 
        ([PARTITION BY columns] [ORDER BY columns] [WINDOWING] )
PARTITION BY : 영역설정
ORDER BY : 영역내에서 순서 설정 (RANK, ROW_NUMBER)
WINDOWING : 파티션 내에서 범위 설정


순위관련 분석함수 - 동일 값에 대한 순위처리에 따라 3가지 함수를 제공
RANK : 동일 값에 대해 동일 순위 부여
       후순위 : 1등이 2명이면 그 다음 순위가 3위 {1, 1, 3
DENSE_RANK : 동일값에 대해 동일 순위 부여
             후순위 : 1등이 2명이면 그 다음순위가 2위 (1 1 2 )
ROW_NUMBER : 동일값이라도 다른 순위를 부여 (1 2 3)

SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

실습 ana1]
SELECT empno, ename, sal, deptno,
        RANK() OVER(ORDER BY sal DESC) sal_rank,
         DENSE_RANK() OVER(ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER() OVER(ORDER BY sal DESC) sal_row_number
FROM emp;

분석함수 - 집계함수
SUM(col), MIN(col), MAX(col), COUNT(col|*), AVG(col)
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

실습 ana2]
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

SELECT  empno, ename, sal, emp.deptno, a.avg_sal
FROM emp , 
    (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
     FROM EMP
     GROUP BY deptno) a
WHERE emp.deptno = a.deptno;

실습 no_ana2 도 해보기 (과제x)

실습 ana3]
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- 복습
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;
------
실습 ana4]
SELECT empno, ename, sal, deptno, MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-----------------------------------------------------------------
분석함수정리
1. 순위 : RANK, DENSE_RANK, ROW_NUMBER
2. 집계 : SUM, AVG, MAX, MIN, COUNT
3. 그룹 행순서 : LAG, LEAD
    현재 행을 기준으로 이전/이후 N번째 행의 컬럼 값 가져오기
    

사원번호, 사원이름, 입사일자, 급여, 급여순위가 자신보다 한단계 낮은 사람의 급여
(단, 급여가 같을 경우 입사일이 빠른 사람이 높은 우선순위)

SELECT empno, ename, hiredate, sal, 
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate ASC)
FROM emp;

ana 5]
SELECT empno, ename, hiredate, sal, 
       LAG(sal) OVER (ORDER BY sal DESC, hiredate ASC)
FROM emp;

ana 6] JOB별로 급여순위가 1단계 높은 사람의 급여
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate ASC) LAG_SAL
FROM emp;


이전/이후 N행 값 가져오기
LAG(col [, 건널띌 행수 - default 1] [, 값이 없을경우 적용할 기본값])
SELECT empno, ename, hiredate, job, sal,
       LAG(sal, 2, 0) OVER (ORDER BY sal DESC, hiredate ASC) LAG_SAL
FROM emp;


그룹내 행 순서
현재 행까지의 누적합 구하기
범위지정 : windowing
windowing에서 사용할 수 있는 특수 키워드
windowing ==> window 함수에 대상이 되는 행을 지정
1. UNBOUNDED PRECEDING ==> 현재 행 기준으로 선행하는 모든 행(이전행)
2. CURRENT ROW ==> 현재행
3. UNBOUNDED FOLLOWING ==> 현재 행 기준으로 후행하는 모든 행(이후행)
4. n PRECEDING (n은 정수) : n행 이전 부터
5. n FOLLOWING (n은 정수) : n행 이후 까지

현재행 이전의 모든 행부터 ~ 현재까지 ==> 행들을 정렬할 수 있는 기준이 있어야 한다.
SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, hiredate ASC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) C_sum
FROM emp;


SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, hiredate ASC 
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) c_sum, 
        SUM(sal) OVER (ORDER BY sal, hiredate ASC 
                       ROWS UNBOUNDED PRECEDING) c_sum2            
FROM emp;

선행하는 이전 첫번째 행부터 후행하는 이후 첫번째 행까지
선행 - 현재행 - 후행 총 3개의 행에 대해 급여 합을 구하기

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, hiredate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

ana7] 급여정보를 [부서별] 로 , 급여, 사원번호 오름차순으로 정렬 했을 때
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno  
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;


SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (ORDER BY sal
                       ROWS UNBOUNDED PRECEDING) rows_sum,
        SUM(sal) OVER (ORDER BY sal
                       RANGE UNBOUNDED PRECEDING) range_sum,
        SUM(sal) OVER (ORDER BY sal) c_sum
FROM emp;

--row 행으로 계산한다
--range 같은 값이 나오면 한번에 같은 값끼리 계산한다
--ORDER BY 절 뒤에 WINDOWING 을 적용하지 않으면 자동으로 RANGE 가 붙는다


DBMS 입장에서 SQL 처리 순서
1. 요청된 SQL과 동일한 SQL이 이미 실행된 적이 있는지 확인하여
   실행된 적이 있다면 SHARED POOL에 저장된 실행계획을 재활용한다
   
    1-2. 만약 SHARED POOL에 저장된 실행 계획이 없다면 (동일한 SQL이 실행된 적이 없음)
         실행계획을 세운다
         
*** 동일한 SQL 이란?? 
  - 결과만 갖다고 동일한 SQL이 아님
  - DBMS 입장에서는 완벽하게 문자열이 동일해야 동일한 SQL임
    다음 SQL은 서로 다른 SQL로 인식한다
    1. SELECT /* SQL_TEST */ * FROM emp;
    2. Select /* SQL_TEST */ * FROM emp;
    3. Select /* SQL_TEST */ *  FROM emp;
    
    부서번호 10번에 속하는 사원 정보 조회
    ==> 특정 부서에 속하는 사원 정보 조회
    
    4. Select /* SQL_TEST */ *  FROM emp WHERE deptno = 10;
       Select /* SQL_TEST */ *  FROM emp WHERE deptno = 20;
       
       바인드 변수를 왜 사용해야 하는가에 대한 설명
       Select /* SQL_TEST */ *  FROM emp WHERE deptno = :deptno;


트랜잭션
ISOLATION LEVEL (고립화 레벨) 후행 트랜잭션이 선행 트랜잭션에 어떻게 영향을 미치는지를 정의한 단계

LEVEL 0~3
LEVEL 0 : READ UNCOMMITED
          선행 트랜잭션이 커밋하지 않은 데이터도 후행 트랜잭션에서 조회된다
          오라클에서는 공식적으로 지원하지 않는 단계
          
LEVEL 1 : READ COMMITTED
          후행 트랜잭션에서 커밋한 데이터가 선행 트랜잭션에서도 조회 된다
          오라클의 기본 고립화 레벨
          대부분의 DBMS가 채택하는 레벨
          
LEVEL 2 : REPREATABLE READ (반복적 읽기)
          트랜잭션안에서 동일한 SELECT 쿼리를 실행해도 트랜잭션의 어떤 위치에서든지
          후행 트랜잭션의 변경(UPDATE), 삭제(DELETE)의 영향을 받지 않고 항상
          동일한 실행결과를 조회 하는 레벨
          
          오라클에서는 공식적으로 지원하지는 않지만 SELECT FOR UPDATE 구문을 통해
          효과를 낼 수 있다
          
          후행 트랜잭션의 변경, 삭제에 대해서는 막을 수 있지만
          (테이블에 기존에 존재 했던 데이터에 대해)
          
          신규(INSERT)로 입력하는 데이터에 대해서는 선행 트랜잭션에 영향이 간다
          ==> Phantom Read(귀신 읽기)
              존재하지 않았던 데이터가 갑자기 조회되는 현상
        
LEVEL 3 : SERIALIZABLE READ (직렬화 읽기)
          후행 트랜잭션의 작업이 선행 트랜잭션에 아무런 영향을 주지 않는 단계
          *** DBMS마다 LOCKING 메카니즘이 다르기 때문에 ISOLATION LEVEL을 함부로
          수정하는 것은 위험하다.

엑셀에 시나리오 참고))



          


          
          
          
          
          
          
          
          
          
          
          
    
          
          
          
          
          
          
          
          
          
          
          



