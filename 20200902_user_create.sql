=SELECT 쿼리 문법=

SELECT * | { column | expression [alias] }
FROM 테이블 이름;

sql. 실행 방법
1. 실행하려고 하는 SQL을 선택후 ctrl + enter;
2. 실행하려고 하는 sql 구문에 커서를 위치시키고 ctrl + enter;


SELECT * 
FROM  emp;

SELECT empno, ename
FROM emp;

SELECT *
FROM dept;

자바언어와 다른점
SQL 의 경우 KEY워드의 대소문자를 구분하지 않는다.

그래서 아래 SQL은 정상적으로 실행된다.
select *
from DEPT;

Coding rule 
수업시간에는 keyword 는 대문자
그 외는 소문자

실습 select1]

SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

연산
SELECT쿼리는 테이블의 데이터에 영향을 주지 않는다.
SELECT 쿼리를 잘못 작성 했다고 해서 데이터가 망가지지 않음.

SELECT ename, sal, sal + 100
FROM emp;
새로 입력한 컬럼도 나온다.

데이터 타입
DESC 테이블명 (테이블 구조를 확인)
DESC emp;

숫자 + 숫자 = 숫자값
5 + 6 = 11

문자 + 문자 ==> java에서는 문자열을 이은, 문자열 결합으로 처리

수학적으로 정의된 개념이 아님
오라클에서 정의한 개념
날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자가 결과로 된다.
날짜 + 숫자 = 날짜

hiredata에서 365일 미래의 일자
별칭 : 컬럼, expression에 새로운 이름을 부여
        컬럼 | experession [AS] [컬럼명]
SELECT ename AS emp_name, hiredate,
hiredate+365 after_lyear, hiredate-365 before_lyear
FROM emp;

=중요하지 않음=
별칭을 부여할 때 주의점
1.공백이나, 특수문자가 있는경우 더블 쿼테이션으로 감싸줘야한다.
2.별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고 싶으면 
 더블 쿼테이션을 적용한다.

SELECT ename "emp name", empno emp_no, empno "emp_no2"
FROM emp;

자바에서 문자열 : "Hello, World"
SQL에서 문자열 : 'Hello, World'

=매우중요=
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다
문자 타입 : ' ' 공백문자와 NULL은 다르다

**** NULL을 포함한 연산의 결과는 항상 NULL
5 * NULL = NULL
800 + NULL = NULL
800 * 0 = 800

emp 테이블 컬럼 정리
1. empno : 사원번호
2. ename : 사원이름
3. jab : (담당)업무
4. mgr : 매니저 사번번호
5. hierdate : 입사일자
6. sal : 급여
7. comm : 성과급
8. deptno : 부서번호




emp 테이블에서 NULL값을 확인
SELECT ename, sal, comm, sal + comm AS total_sal
FROM emp;

SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;

column alias(실습2)

SELECT prod_id id , prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


literal : 값 자체
literal 표기법 : 값을 표현하는 방법

숫자 10이라는 값을 
java : int a = 10;

SQL : SELECT empno, 10
      FROM emp;

문자 Hello, World 라는 문자 값을
java : String str = "Hello, World";
        컬럼 별칭, expression 별칭, 별칭
sql : SELECT empno e, 'Hello, World' h--, 'Hello, World'      
      FROM emp;


날짜 2020년 9월 2일이라는 날짜 값을..
java : primitive type(원시타입) : 8개 - int, long, byte, short, float, 
                                      double, char, boolean
                                      문자열 => String class
                                      날짜 => Data class
sql : 

문자열 연산
java 
    "Hello," + "World" ==> "Hello, World"
    "Hello," - "World" : 연산자가 정의되어 있지 않다.
    "Hello," * "World" : 연산자가 정의되어 있지 않다.

python
"Hello," * 3  => "Hello,Hello,Hello"

sql ||, CONCAT 함수 ==> 결합 연산
    emp테이블의 ename, job 컬럼이 문자열
    
   java:  ename + " " + job
    sql:  ename || ' ' || job
    
    CONCAT(문자열1, 문자열2) : 문자열1과 문자열2를 합쳐서 
                            만들어진 새로운 문자열을 반환해준다.
    
    5 + 6 + 7
    'test' || 'test'
    
   
    SELECT  ename, ' ', job,
            ename || ' ' || job,
            CONCAT(ename, ' '),
            CONCAT(CONCAT(ename, ' '),job)
    FROM emp;
    

USER_TABLES : 오라클에서 관리하는 테이블(뷰)
            접속한 사용자가 보유하고 있는 테이블 정보를 관리
            

( 문자열 결합 실습 sel_con1)
SELECT 'SELECT * FROM ' || table_name ||';' QUERY
FROM user_tables;

SELECT *
FROM user_tables;

 테이블의 구조(컬럼명, 데이터타입) 확인하는 방법
 1. DESC 테이블명 : DESCRIBE
 2. 컬럼 이름만 알 수 있는 방법(데이터 타입은 유추)
    SELECT *
    FROM 테이블명;
3. 툴에서 제공하는 메뉴 이용
    접속 정보 - 테이블 - 확인 하고자하는 테이블 클릭
    
SELECT empno, ename, sal
FROM emp;


*********매우매우매우 중요*************
WHERE 절 : 조건에 만족하는 행들만 조회되도록 제한 (행을 제한)
        ex) sal 컬럼의 값이 1500보다 큰 사람들만 조회 ==> 7명
    WHERE절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다 
        
조건 연산자
    동등 비교(equal)
        java : int a = 5;
            primitive type : ==  ex)a == 5,
            object : "+".equals("-")
        sql : sal = 1500
       
       not equal
        java : !=
        sql : != , <>
        
        대입연산자
        java :  =
        sql :  :=
   SQL은 대소문자를 가리지 않는다 : 키워드, 테이블명, 컬럼명
    데이터는 대소문자를 가린다
   
    users테이블에는 총 5명의 캐릭터가 등록이 되어있는데
    그중에서 userid 컬럼의 값이  'brown'인 행만 조회되도록
    WHERE절에 조건을 기술
        SELECT userid, usernm, alias, reg_dt
        FROM users
        WHERE userid = 'brown';
        
 WHERE절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다 
 
컬럼과 문자열 상수를 구분하여 사용

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 1 = 1;

emp테이블에서 부서번호(deptno)가 30보다 크거나 같은 사원들만 조회
컬럼은 모든 컬럼 조회

SELECT *
FROM emp
WHERE deptno >= 30;

날짜 비교
1982년 01월 01일 이후에 입사한 사람들만 조회(이름, 입사일자)
dhiredate type : date
문자 리터럴 표기법 : '문자열'
숫자 리터럴 표기법 : 숫자
날짜 리터럴 표기법 : 항상 정해진 표기법이 아니다. 
                  서버 설정마다 다르다
                  한국 :   yy/mm/dd
                  서양권 : mm/dd/yy 
                  
날짜 리터럴 결론 : 문자열 형태로 표현하는 것이 가능하나
                서버 설정마다 다르게 해석할 수 있기 때문에
                서버 설정과 관계없이 동일하게 해석할 수 있는 방법으로 사용
                TO_DATE('날짜문자열','날짜문자열형식')
                 : 문자열 ==> 날짜 타입으로 변경
년도 : yyyy
월 : mm
일 : dd
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982-01-01', 'yyyy-mm-dd');


BETWEEN AND 연산자 
WHERE 비교대상 BETWEEN 시작값 AND 종료값;
비교대상의 값이 시작값과 종료값 사이에 있을 때 참(TRUE)으로 인식
(시작값과, 종료값을 포함  비교대상 <= 시작값, 비교대상 >= 종료값)

emp테이블에서 sal 컬럼의 값이 1000이상 2000이하인 사원들의 모든 컬럼을 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000; 

비교 연산자를 이용한 풀이
SELECT *
FROM emp
WHERE sal >= 1000
     AND sal <= 2000;  
    AND를 붙여줘야 오류가 안난다.
    
    where 1]
    입사일자가 82년 1월 1일 ~ 83년 1월 1일 사이에 있는 사원 조회(전체 컬럼 조회)
    WHERE 비교대상 BETWEEN 시작값 AND 종료값;
    
    SELECT ename, hiredate
    FROM emp
    WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD') 
    AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
    
    where 2]
    
    SELECT ename, hiredate
    FROM emp
    WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
        AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

IN 연산자
 특정 값이 집합(여러개의 값을 포함)에 포함되어 있는지 여부를 확인
 OR연산자로 대체하는 것이 가능
 
 WHERE 비교대상 IN (값1, 값2...)
 ==> 비교대상이 값1 이거나 (=)
     비교대상이 값2 이거나 (=)
    
 WHERE 비교대상 = 값1
    OR 비교대상 = 값2
 
 emp테이블에서 사원이 10부서 혹은 30부서에 속한 사원들 정보를 조회(모든 컬럼)
 SELECT *
 FROM emp
 WHERE deptno IN (10, 30);


SELECT *
 FROM emp
 WHERE deptno = 10
        OR deptno = 30;
        
        실습3]
        SELECT *
        FROM users
        
       문자열 표현:  userid 'userid' "userid"
        
        SELECT userid 아이디 , usernm 이름, ALIAS 별명 
        FROM users
        WHERE userid IN ('brown', 'cony', 'sally');
        
        //문자열 은 '  ' 로 표현한다. 그냥 brown으로 검색하면 컬럼을 찾는것.
        
        <OR로 표현>
        SELECT userid 아이디 , usernm 이름, ALIAS 별명 
        FROM users
        WHERE userid ='brown'
        OR userid = 'cony'
        OR userid = 'sally';
        
AND ==> 그리고
OR ==> 또는

조건1 AND 조건2 ==> 조건1과 조건2를 동시에 만족
조건1 OR 조건2 ==> 조건1을 만족하거나, 조건2를 만족하거나
                  조건1과 조건2를 동시 만족하거나
                  
 LIKE 연산자 : 문자열 매칭
 WHERE userid = 'brown'
 userid가 b로 시작하는 캐릭터만 조회
 % : 문자가 없거나, 여러개의 문자열
 
 _ : 하나의 임의의 문자
 
 => ename이 w로 시작하고 이어서 3개의 글자가 있는 사원
 SELECT *
 FROM emp
WHERE ename LIKE 'W___';   

실습4]
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

** WHERE mem_name LIKE '신__' ->이름이 무조건 3글자인 사람만 나온다.

실습5]
member 테이블에서 이름에 [이]라는 글자가 포함된 사람
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


SELECT empno "ename"  
FROM emp;

SELECT *
FROM emp
WHERE 10 BETWEEN 10 AND 50;








