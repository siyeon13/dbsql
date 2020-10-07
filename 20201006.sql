변수선언
JAVA : 변수타입 변수이름;
PL/SQL : 변수이름 변수타입;

어제까지
변수 : 스칼라 변수(하나의 값만 담을 수 있는 변수)

복합변수
1. %ROWTYPE 행 정보(컬럼이 복수)를 담을 수 있는 변수(rowtype)
    ==> java로 비유를 하면 vo(filed가 여러개)
    컬럼 타입 : 테이블명.컬럼명%TYPE
    ROW 타입 : 테이블명%ROWTYPE
    
2. record type : 행 정보, 개발자가 컬럼을 선택하여 타입 생성
3. table type : 행이 여러개인 값을 저장할 수 있는 변수

%ROWTYPE : 테이블의 행정보를 담을 수 있는 변수


SET SERVEROUTPUT ON;

emp 테이블에서 7369번 사번의 모든 컬럼 정보를 ROWTYPE 변수에 저장
DBMS_OUTPUT.PUT_LINE 함수를 통해 콘솔에 출력

SELECT *
FROM emp
WHERE empno = 7369;


DECLARE
    v_emp_row emp%ROWTYPE; /* v_emp_row.empno, v_emp_row.ename */
BEGIN
    SELECT * INTO v_emp_row
    FROM emp
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(' v_emp_row.empno :' || v_emp_row.empno  || ', v_emp_row.ename : ' ||  v_emp_row.ename);  
END;
/

RECORD TYPE : 행의 컬럼정보를 개발자가 직접 구성한 (커스텀) 타입
    => 지금까지는 타입을 가져다 사용한 것, 지금은 타입을 생성(CLASS를 생성)
    
방법
TYPE 타입이름 IS RECORD (
    컬럼명1 컬럼타입1, 
    컬럼명2 컬럼타입2,
    컬럼명3 컬럼타입3
);
변수명 타입이름;

사원테이블에서 empno, ename, deptno 3개의 컬럼을 저장할 수 있는 ROWTYPE 타입을 정의하고
해당 타입의 변수를 선언하여 사번이 7369번인 사원의 위 3가지 컬럼 정보를 담아본다.

DECLARE
    TYPE t_emp_row IS RECORD(
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        deptno emp.deptno%TYPE
    );
    
    v_emp_row t_emp_row; --변수이름 변수타입
    
BEGIN
    SELECT empno, ename, deptno INTO v_emp_row
    FROM emp
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE(' v_emp_row.empno :' || v_emp_row.empno  || ', v_emp_row.ename : ' ||  v_emp_row.ename);  
END;
/


TABLE 타입 : 여러개의 행을 담을 수 있는 타입
    자바로 비유하면 List<Vo>
    
자바 배열과 pl/sql table 타입과 차이점
int [] intArr = new int[10];
배열의 첫번째 값을 접근 : intArr[0] index 번호 ==> 숫자로 고정
pl/sql intArr["userName"]

테이블 타입선언
TYPE 테이블_타입이름 IS TABLE OF 행에대한타입 INDEX BY BINARY_INTEGER;
테이블_타입_변수명 테이블_타입이름;

기존 : SELECT 쿼리의 결과가 한 행이어야만 정상적으로 통과
변경 : SELECT 쿼리의 결과가 복수 행이어도 상관 없다

dept테이블의 모든행을 조회해서 테이블 타입변수에 담고
테이블 타입변수를 루프(반복문)를 통해 값을 확인

DECLARE
    TYPE t_dept IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept t_dept; 
BEGIN
    /*자바 배열 : v_dept[0]
    자바 list : v_dept.get(0)
    pl/sql 테이블타입 : v_dept(0).컬럼명 */
    
    
    SELECT * BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE( 'v_dept(i).deptno : ' ||  v_dept(i).deptno || ', v_dept(i).dname' || v_dept(i).dname);
    END LOOP;

END;
/

조건제어
    IF
    CASE-2가지
반복문
    FOR LOOP
    LOOP
    WHILE

    
IF 로직제어
IF 조건문 THEN
    실행문장;
ELSIF 조건문 THEN
    실행문장;
ELSE
    실행문장;
END IF;

DECLARE
    
   /* p NUMBER;
    p := 5; --할당 연산자 주의 */
    p NUMBER := 5;
BEGIN
    --if(p==1)
    IF p = 1 THEN   -- =는 대입이 아니다
        DBMS_OUTPUT.PUT_LINE('p=1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('p=2');
    ELSIF p = 5 THEN
        DBMS_OUTPUT.PUT_LINE('p=5');
    ELSE
        DBMS_OUTPUT.PUT_LINE('DEFAULT');
    END IF;
END;
/

일반 CASE 
CASE expression(컬럼이나, 변수, 수식)
    WHEN value THEN
        실행할 문장;
    WHEN value2 THEN
        실행할 문장2;
    ELSE
        기본실행문장;
END CASE;
        

--IF로 작성한 PL/SQL을 CASE문으로 바꾸기
[CASE 기본 케이스]
DECLARE
    p NUMBER := 5;
    
BEGIN
    
    CASE P
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('p=1');
        WHEN 2 THEN
             DBMS_OUTPUT.PUT_LINE('p=2');
        WHEN 5 THEN
             DBMS_OUTPUT.PUT_LINE('p=5');
        ELSE
            DBMS_OUTPUT.PUT_LINE('DEFAULT');
        END CASE;  
END;
/

[CASE 검색 케이스]
DECLARE
    p NUMBER := 3;
    
BEGIN
    CASE 
        WHEN p=1 THEN
            DBMS_OUTPUT.PUT_LINE('p=1');
        WHEN p=2 THEN
             DBMS_OUTPUT.PUT_LINE('p=2');
        WHEN p=5 THEN
             DBMS_OUTPUT.PUT_LINE('p=5');
        ELSE
            DBMS_OUTPUT.PUT_LINE('DEFAULT');
        END CASE;  
END;
/

-----------------------------------------
case 표현식 : SQL에서 사용한 CASE
변수 :=    CASE
             WHEN 조건문1 THEN 반환할 값1
             WHEN 조건문2 THEN 반환할 값2
             ELSE 기본 반환값
           END;
----------------------------------------          
SELECT *
FROM emp;

emp 테이블에서 7369번 사원의 sal 정보를 조회하여
sal 값이 1000보다 크면 sal*1.2값을 
sal 값이 900보다 크면 sal*1.3 값을
sal 값이 800보다 크면 sal*1.4 값을
위 세가지 조건을 만족하지 못할 때는 sal*1.6값을 
v_sal 변수에 담고 emp 테이블의 sal 컬럼에 업데이트 
단 case 표현식을 사용할 것

1.7369번 사번의 SAL 정보를 조회하여 변수에 담는다
2.1번에서 담은 변수값을 CASE 표현식을 이용하여 새로운 sal 값을 구하고
  v_sal 변수에 할당
3.7369번 사원의 sal 컬럼을 v_sal 값으로 업데이트


DECLARE
    v_sal emp.sal%TYPE;
BEGIN
    
    SELECT sal INTO v_sal 
    FROM emp
    WHERE empno = 7369;
    
    CASE
        WHEN v_sal > 1000 THEN v_sal := v_sal*1.2;
        WHEN v_sal > 900 THEN v_sal := v_sal*1.3;    
        WHEN v_sal > 800 THEN v_sal := v_sal*1.4;
        ELSE v_sal := v_sal*1.6;
    END CASE; 
    
    UPDATE emp SET sal = v_sal WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE( v_sal);
END;
/



SELECT *
FROM EMP;

반복문
1. FOR LOOP : 루프를 실행 할 데이터의 갯수가 정해져 있을 때
    for(int i = 0; i < list.size(); i++){}
2. LOOP
3. WHILE : 루프 실행 횟수를 모를 때, 루프 실행 조건이 로직에 의해 바뀔 때

FOR LOOP
FOR 인덱스변수(개발자가 이름부여) IN [REVERSE] 시작인덱스...종료인덱스 LOOP
    반복실행할 문장;
END LOOP;

1-5까지 출력
SET SERVEROUTPUT ON;

DECLARE
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/



2-5단까지 구구단 연산 (포멧 신경쓰지 말고)
DECLARE
BEGIN
    FOR i IN 2..5 LOOP
    DBMS_OUTPUT.PUT_LINE(i||'단');
        FOR j IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(i ||'*'|| j || ' = ' || i*j);
        END LOOP;
    END LOOP;
END;
/


WHILE
java

while(조건식) {
}

WHILE 조건식 LOOP
    반복할 문장;
END LOOP;

DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
        END LOOP;
END;
/


SQL CURSOR : SELECT 문에 의해 추출된 데이터를 가리키는 포인터

SELECT 문 처리 순서
1. 실행계획 생성 OR 기 생성된 계획 찾기 
2. 바인드 변수처리
3. 실행
4. ******** 인출

커서를 통해 개발자가 인출 하는 과정을 통제함으로써
테이블 타입변수에 SELECT 결과를 모두 담지 않고도 (메모리 낭비 없이)
효율적으로 처리하는 것이 가능하다

커서의 종류
1. 묵시적 커서 - 커서 선언없이 실행한 SQL에 대해 오라클 서버가 스스로 생성, 억제하는 커서
2. 명시적 커서 - 개발자가 선언하여 사용하는 커서

커서의 속성
    커서명%ROWCOUNT : 커서에 담긴 행의 갯수
    커서명%FOUND : 커서에 읽을 행이 더 있는지 여부
    커서명%NOTFOUND : 커서에 읽을 행이 더 없는지 여부
    커서명%ISOPEN : 커서가 메모리에 선언되어 사용 가능한 상태 여부
    
커서 사용법
1. 커서 선언
    CURSOR 커서이름 IS 
        SELECT 쿼리
        
2. 커서 열기
    OPEN 커서이름;
    
3. 커서로부터 패치
    FETCH 커서이름 INTO 변수;
    
4. 커서 닫기
    CLOSE 커서이름;
    
DEPT 테이블의 모든 부서에 대해 부서번호, 부서이름을 CURSOR를 통해
데이터 출력

SELECT deptno, dname
FROM dept;

DECLARE
    /* 커서선언 */
    CURSOR c_dept IS 
        SELECT deptno, dname
        FROM dept;
        
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN
    /* 커서열기 */
    OPEN c_dept;
    
    /* 데이터 패치 */
    LOOP
        FETCH c_dept INTO v_deptno, v_dname;
        EXIT WHEN c_dept%NOTFOUND;             --조건
        DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
    END LOOP;
    
    CLOSE c_dept;
END;
/


명시적 커서 FOR LOOP : FOR LOOP와 명시적 커서를 결합한 형태로
                     커서 OPEN, FETCH, CLOSE 단계를 FOR LOOP에서 처리하여
                     개발자가 사용하기 쉬운형태로 제공
사용방법 (JAVA 향상된 FOR 문과 비슷)
    for(String name : names)
FOR 레코드이름 IN 커서 LOOP
    반복할 문장;
END LOOP;



DECLARE
    /* 커서선언 */
    CURSOR c_dept IS 
        SELECT deptno, dname
        FROM dept;
        
        v_deptno dept.deptno%TYPE;
        v_dname dept.dname%TYPE;
BEGIN

    FOR rec IN c_dept LOOP
        DBMS_OUTPUT.PUT_LINE('rec.deptno : '||rec.deptno || 'rec.dname' || rec.dname);
      
    END LOOP;
END;
/

파라미터가 있는 커서  : 함수처럼 커서에 인자를 전달해서 실행시 조건을 추가 할 수 있다.
FROM emp
WHERE deptno = 10;

FROM emp
WHERE deptno = 20;

커서 선언시 인자 명시
CURSOR 커서이름(파라미터명 파라미터타입) IS
    SELECT *
    FROM emp
    WHERE deptno = 파라미터명;


emp 테이블의 특정 부서에 속하는 사원들을 조회할 수 있는 커서를
커서 파라미터를 통해 생성 (사원이름, 사원번호)

DECLARE
    CURSOR c_emp (p_deptno dept.deptno%TYPE) IS
        SELECT empno, ename
        FROM emp
        WHERE deptno = p_deptno;

BEGIN
    FOR rec IN c_emp(10) LOOP
    DBMS_OUTPUT.PUT_LINE('rec.empno : ' || rec.empno || ', rec.ename : ' || rec.ename);
    END LOOP;

END;
/


 커서가 짧을 경우 FOR LOOP에 커서를 인라인 형태로 작성하여 사용가능
    ==> DECLARE 절에 커서를 선언하지 않음
FOR 레코드명 IN (SELECT 쿼리) LOOP 
END LOOP;


DECLARE
 
BEGIN

    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE('rec.deptno : '||rec.deptno || 'rec.dname' || rec.dname);
      
    END LOOP;
END;
/


SELECT (SYSDATE +5) - SYSDATE
FROM dual;

SELECT *
FROM dt;



                   
생성방법
CREATE OR REPLACE PROCEDURE 프로시저명 [(입력값....)] IS 
    선언부
BEGIN
END;
/

실행방법
EXEC 프로시저명;

CREATE OR REPLACE PROCEDURE avgdt IS
    v_dt dt.dt%TYPE;
BEGIN
    SELECT dt INTO v_dt
    FROM dt;
    DBMS_OUTPUT.PUT_LINE(v_dt);
END;
/




CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
    diff_sum NUMBER := 0;
BEGIN
    SELECT dt BULK COLLECT INTO v_dt
    FROM dt
    ORDER BY dt DESC;
    
    FOR i IN 1..v_dt.COUNT-1 LOOP
        diff_sum := diff_sum + v_dt(i).dt - v_dt(i+1).dt;
        DBMS_OUTPUT.PUT_LINE(  v_dt(i).dt || ' , ' ||v_dt(i+1).dt);    
        DBMS_OUTPUT.PUT_LINE(diff_sum);  
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(diff_sum / (v_dt.COUNT-1));
END;
/



exec avgdt;

**avgdt와 동일한 기능을 하는 select 쿼리를 분석함수를 사용하여 만들어라
SELECT *
FROM DT;

SELECT dt, LEAD(dt) over (ORDER BY dt DESC) lead_dt ,dt -  LEAD(dt) over (ORDER BY dt DESC) diff
FROM dt;
--아래가 답
SELECT AVG(diff)
FROM
(SELECT dt -  LEAD(dt) over (ORDER BY dt DESC) diff
FROM dt);

**최대값이랑 최소값만  알면 구할 수 있다

SELECT (MAX(dt) - MIN(dt)) / (COUNT(*)-1) diff_avg 
FROM dt;













