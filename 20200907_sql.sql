실습 11]
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');

실습 12]
DESC emp;

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';


실습 13]

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
    OR (empno BETWEEN 7800 AND 7899; 
    OR empno BETWEEN 78 AND 78;
    OR empno BETWEEN 780 AND 789);

실습 14]
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%'
AND hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');

ROWNUM : 1 부터 읽어야 된다.
        SELECT 절이 ORDER BY 절보다 먼저 실행된다.
                => ROWNUM을 이용하여 순서를 부여 하려면 정렬부터 해야한다.
                => 인라인뷰 ( ORDER BY ~ ROWNUM을 분리)
                
              실습 ROW_1
                SELECT ROWNUM RN, empno, ename
                FROM emp
                WHERE ROWNUM <= 10;
                
            실습 ROW_2
                SELECT ROWNUM RN, empno, ename
                FROM emp
                WHERE ROWNUM IN (11, 20);       //잘못된 문장
                
                SELECT *
                FROM(
                 SELECT ROWNUM RN, empno, ename
                FROM emp )
                WHERE RN >=11 AND RN <= 20;
                
                실습_3
                emp 테이블에서 사원이름을 오름차순 정렬하고 
                11-14번에 해당하는 순번, 사원번호, 이름 출력
                1.정렬기준 : ORDER BY ename ASC;
                2.페이지 사이즈 : 11~20(페이지당 10건)
                
                SELECT *
                FROM
                (SELECT ROWNUM rn, empno, ename
                FROM
                (SELECT empno, ename
                FROM emp
                ORDER BY ename ASC))
                 WHERE rn >=11 AND rn <= 20;
                
                * SELECT 절이 ORDER BY 절보다 먼저 실행된다 *
               
                SELECT * 
                FROM
                (SELECT ROWNUM rn, empno, ename
                FROM 
                (SELECT empno, ename
                FROM emp
                ORDER BY ename ASC))
                WHERE rn >=11 AND rn <= 14;
                
     
                SELECT * 
                FROM dual;
                
                SELECT dummy 
                FROM dual;
            
  oracle 함수 분류
1. SINGLE ROW FUNCTION :  단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW FUNCTION : 여러행을 작업의 기주느 하나의 행동결과고 별견

dual 테이블
1.eye 계정에 존재하는 누구나 사용할 수 있는 테이블
3.하나의 행만 존재
****** 

SELECT empno,ename, LENGTH('hello')
FROM emp;

SELECT em,ename,
                
            
            SELECT ename, LOWER(ename)
            FROM emp
            WHERE LOWER(ename) = 'smith';
        
        (같은거)  SELECT ename, LOWER(ename)
            FROM emp
            WHERE LOWER(ename) = UPPER('smith');
                 WHERE ename = SMITH;
                
    sql 칠거지악
    1.좌변을 가공하지 말아라 ( 테이블 컬럼에 함수를 사용하지 말것
    -함수 싱행 횟수
    -인덱스 사용관련
    
    문자열 관련함수
    SELECT CONCAT('Hello'    ,   ', World') concat,
            SUBSTR('Hello, World', 1, 5) subsr,
            SUBSTR('Hello, World', 5) substr2,
            LENGTH('Hello, World') length,
            INSTR('Hello, World', 'o')instr,
            INSTR('Hello, World', 'o', 5 + 1)instr2,
            INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1 )instr3,
            LPAD('Hello, World', 15, '*')lpad,
            LPAD('Hello, World', 15 )lpad,
            RPAD('Hello, World', 15, '*')rpad,
            REPLACE('Hello, World', 'Hello', 'Hell')replace,
            TRIM('Hello, World')trim,
            TRIM('     Hello, World     ' )trim2,
            TRIM( 'H' FROM 'Hello, World')trim3
    FROM dual;
                //substr " 1부터 5번째 글 까지 잘라내는?
                
숫자 관련 함수
ROUND : 반올림 함수
TRUSC : 버림 함수 (내림)
    ==> 몇번째 자리에서 반올림, 버림을 할지?
       두번째 인자가 0, 양수 : ROUND(숫자, 반올림 결과 자리수)
        두번째 인자가 음수 : ROUND(숫자, 반올림 해야되는 위치)
        ROUND(숫자, 반올림 결과 자리수)
MOD : 나머지를 구하는 함수
 피제수 - 나눔을 당하는 수, 제수 - 나누는 수
 a / b = c 
 a : 피제수
 b : 제수
 
               
        SELECT ROUND(105.54, 1)round,
                ROUND(105.55, 1)round2,
                ROUND(105.55, 0)round3,  -- 소수점 0번째 자리
                ROUND(105.55, -1)round4  --105에서 5가 반올림 되서 106이 된다
        FROM dual;
             -- 반올림을 해서 소수점 첫째자리까지
             
        SELECT TRUNC(105.54, 1)trunc,
                TRUNC(105.55, 1)trunc2,
                TRUNC(105.55, 0)trunc3,  
                TRUNC(105.55, -1)trunc4  
        FROM dual;     
  
  TRUSC : 버림 함수 (내림)    
  
        SELECT MOD(105.54, 1)mod,
                MOD(105.55, 1)mod2,
                MOD(105.55, 0)mod3,  
                MOD(105.55, -1)mod4  
        FROM dual;              
                
MOD : 나머지를 구하는 함수
 피제수 - 나눔을 당하는 수, 제수 - 나누는 수
 a / b = c 
 a : 피제수
 b : 제수             
        10을 3으로 나눴을 때의 몫을 구하기
        -> TRUNC 를 씀
        
        SELECT mod(10, 3), 10*3, 10/3, TRUNC(10/3, 0)
        FROM dual;
         
 날짜 관련 함수
 문자열==> 날짜 타입 TO_DATE
 SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
            함수의 인자가 없다
            (java
            public void test(){
            }
            test();
            
            SQL
            length('Hello, World')
            SYSDATE ;
            
           SELECT SYSDATE
           FROM dual;
           
 날짜 타입 +- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜
 하루 = 24
 1일 = 24h
 1/24시간 = 1h
 1/24/60 = 1m
 1/24/60/60 = 1s
  emp hiredate  + 5, - 5
        
 SELECT SYSDATE , SYSDATE + 5, SYSDATE - 5,
        SYSDATE + 1/24, SYSDATE + 1/24/60
 FROM dual;
        
     date 실습_1
     
     SELECT  TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDATE,
            TO_DATE('2019/12/31', 'YYYY/MM/DD')-5 "LASTDATE BEFORES",        --공백이 있는 별칭은 ""
            SYSDATE NOW,
            SYSDATE - 3 NOW_BEFORE3
            
     FROM dual;

        
        
        
        
        
        
        
        
        
                
                
                