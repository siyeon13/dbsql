데이터 모델링 흐름
1. 요구사항 파악
    . 요구사항 정의서
    . 현업 담당자와의 인터뷰(***)
    . 워크샵 ==> 관리자들끼리 모여서 회희
            ==> (술먹고 노는자리)
    . 기존 시스템(legacy system)
2. 엔티티 타입 정의
    . 데이터를 담는 그릇 (스프레드 시트에서 표를 만드는 작업)
    . 명사를 확보 
      가구 
      
3. 속성 정의
    . entity type에 속하며 의미상으로 분리되지 않는 데이터 표현의 최소 단위
        학생 : 이름, 집주소, 핸드폰 번호, 집전화 번호....
    . 일반 / 식별자 속성
    
    entity type : 데이터를 담는 그릇
    entity : 속성들로 이루어진 하나의 데이터(table 1개의 row, 학생 한명, 사원 한명)
    
    속성 구분
    식별자 속성 : entity 구분지어줄 수 있는 속성(학생 - 학번, 사원 - 사번)
    일반 속성 : 업무분석을 통해 정의 된 속성
        . 설계 속성 : 업무에 존재하지 않지만 시스템 설계 과정에서 도출 된 속성
                    (코드속성 : 상담 엔터티의 상담코드 : 
                                   01-1일반상담, 02-상품신청, 03-사용문의)
        파생 속성 : 다른 속성으로 부터 계산된 값
                   게시글의 첨부파일 개수
                   엔터티 : 게시글, 첨부파일
                            해당 게시글 첨부파일 수는 첨부파일 엔터티를 통해서 조회가능
                            (SELECT COUNT(*)
                            FORM 첨부파일
                            WHERE 게시글번호 = 내가 원하는 게시글번호;)
                            ==> 쿼리를 매번 이렇게 귀찮아서 게시글 엔터티에 첨부파일 개수라는
                                컬럼을 만들고, 첨부파일 수가 수정이 될 때마다 첨부파일, 게시글 엔터티를 동시에 수정
                                ==> 반정규화, 로직을 잘못 작성하게 되면 첨부파일 테이블의 행 개수와, 게시글 엔터티의
                                    첨부파일 수가 불일치 할 수도 있다
        관계 속성(FK) : 다른 엔터티와 관계를 통해 생성되는 속성
        
        엔터티, 속성 : 네이밍 규칙
            1. 명사형 : 서술식으로 사용하지 않는다
               ex) 학생, 학생정보를 저장하는 엔터티
            2. 업무에서 사용하는 공식용어를 사용할 것
               ex : Y사의 판매점, 비공식-여사님, 아줌마
            3. 약어사용은 가급적 자제
               (테이블 컬럼 생성시에는 상황에 따라 사용
                name ==> nm)
                
        식별자 분류
        1. 단일속성여부
            .식별 속성이 한개: 단일 식별자
            .식별 속성이 여러개: 복합 식별자
        2. 대체 여부
            .대체 되지 않은 원래의 식별자 : 본질 식별자
            .본질 식별자를 놔두고 새롭게 만든 가짜 식별자 : 대체 식별자
            
            **기준이 모호하다
            학생-학번 : 대체 식별자, 본식별자 인가??
            본질 식별자 : 누가, 언제, 무엇을
            학생 엔터티 : 학생이(xx 학생), 등록일자, 등록을 
                        학생이름, 등록일자 ==> 학번 
                        
                        WHERE 누가 = '학생이름'
                        AND   언제 = TO_DATE('20201012 14:47', 'YYYYMMDD HH24:MI')
                        
                        WHERE 학번 = '15101001';
    
4. 관계 정의
    관계 : 두 엔터티간의 존재하는 업무 규정, 흐름, 논리적인 관계
    
    관계구성
        1. 이름(툴마다 표현 방식이 다름)
        2. 차수 : 몇개의 엔터티와 연관(대응) 되는지
                 RDBMS에서는 차수가 1:1, 1:N 관계만 허용
                 만약 설계시에 N:N관계가 나오게 되면 추가적인 관계 엔터티를 통해
                 N:N관계를 1:N 관계로 해소를 해야한다
                 
                ex : 사원은 하나의 부서에 속한다
                     상품은 여러개의 주문을 통해 주문될 수 있다
                     학생은 여러개의 교과목을 수강할 수 있다
        3. 옵션여부 : 관계에 연결된 상대 엔터티가 반드시 존재해야되는지 여부
            ex : 학생은 교과목을 수강 할 수도 있다
                ==> 교과목에 등록되어 있는 모든 과목을 학생이 수강하지 않아도 됨
            ex : 부서에는 사원이 반드시 소속되어야 한다
                ==> 사원이 없는 부서는 있을 수가 없다
        4. 식별자 상속(identifier inheritence)
           두 엔터티간 관계를 맺게되면 부모 엔터티의 식별자가
           자식 엔터티의 식별자 속성, 일반 속성을 생성하게 됨
           
         관계차수, 옵션여부는 요구사항에 따라 정의를 하면 됨
       관계명은 모델러가 직접 작명을 해야하나 어려운 영역으로 보긴 힘듬
       
       식별자 상속은 모델러의 판단 기준에 따라 해석이 달라질 수 있어 명확하게
       이게 답이다 라고 말하기 힘든 부분이 있음 
       
       하지만 요구사항을 만족하는 전제조건이 있다면 
       1. 식별속성을 먼저 고려 해볼 것
       2. 키가 복잡해진다, 손자 엔터티가 나올것 같지 않음
           ==> 비식별 관계 
           (학생의 자식 엔터티가 수강, 손자라는 것은 수강에서 파생된 엔터티)
     
  모델링 순서
  개괄 모델링 => 개념 모델링 => 논리 모델링 => 물리 모델링
  개념 모델링 : 논리 모델링을 그리기 전에 엔터티와 엔터티의 식별자만 그려보는 단계
              일반 속성을 부수적인 것이기 때문에 배제 
  논리 모델링 : 실제 시스템 구현과 관계없이 데이터의 흐름을 표현한 모델
  물리 모델링 : 설계 된 논리 모델링을 시스템에서 사용할 데이터 베이스에 맞게 설계한 모델
              (데이터 타입, 객체명, 컬럼명, 제약조건 - PK, FK)
     
 Super Type / Sub Type
 java의 클래스 상속처럼 공통 분모를 Super Type entity에 설계하고
 sub type마다 필요로 하는 속성은 별도로 관리
 
 ex : 사원의 종류가 내근사원, 설계사, 대리점 3개로 구분되고
 3분류가 공통으로 갖고있는 속성과, 별도로 갖는 속성이 있을 때
 공통 속성은 SuperType에
 개별 속성은 subType을 통해 관리 할 수 있다
 
 Super Type, sub Type을 물리 모델로 변경하게 될 경우 선택 방안은 3가지가 존재
 1. Super Type + 모든 sub Type 통합 (생성되는 테이블 수 : 1)
    하나의 테이블로 모든 속성을 넣는 형태로, 단점은 null값을 갖는 컬럼이 많아 질 수 있음
 2. Super Type + sub Type (생성되는 테이블 수 : sub type 개수만큼)
    sub type별로 테이블을 생성
 3. Super Type, sub Type 각각 생성(생성되는 테이블 수 : super type, sub type 개수 만큼)
    자바의 클래스 상속과 유사
    
1~3 방법중 명확한 선택 기준은 없다 - 개인 판단 영역
sub type별 별도 속성의 개수가 많지 않으면 1번을 고려 (유지보수차원)
sub type 속성과 super type 속성의 개수가 비슷할 경우
    단 sub type의 개수가 적을 경우 : 2번
    단 sub type의 개수가 많을 경우 : 3번
        
5. 정규화(normalize) : 데이터 중복을 최소화 하게 구조화하는 프로세스
   정규형(normalization) : 정규화의 작업으로 나온 결과물
   
   정규화 순서 : 1정규형 - 2정규형 -3장규형 - BCNF 정규형 - 4정규형 - 5정규형
        순서가 정해져 있음. 3정규형은 1,2, 정규형이 끝난 상태에서 진행
        실무에서는 1~3 정규형 까지만 진행, 3정규형 이후 부터는 발생 빈도가 낮아지고, 수고 커짐
        
함수 종속
a라는 값을 통해 b라는 값이 정해지는 것 ( a -> b)
사번 -> 사원이름, 담당업무, 소속부서, 급여, 매니저
7369 -> SCOTT (brown)
SCOTT (brown) -> 사번을 유추할 수 있나? 


1 정규형 : 반복속성을 별도의 엔터티로 분리
          (게시글의 첨부파일1~5번까지 관리를 위한 5개의 컬럼을
            첨부파일 엔터티라는 별도의 엔터티로 분리
            ==> 첨부파일이 추가가 될때 컬럼 구조 변경이 아니라
                데이터의 행 추가로 문제점을 해결(테이블 구조 변화가 없다)
        
2 정규형 : 주 식별자에 종속이지 않은 속성을 분리
         2 정규형의 대상은 복합 식별자를 갖는 엔터티
         복합 식별자의 일부 식별자 속성에만 종속적인 속성을 분리
         (학생, 수강, 강좌 3개의 엔터티가 있고, 수강 엔터티는 학생번호, 강좌번호
          두개의 복합 식별자로 이루어져 있었고, 일반 속성으로 학생이름이 있었음.
          학생이름은 학생번호 식별자 속성에만 종속이 되고, 강좌번호와는 관련이 없었음
          즉 학생이름은 학생번호와 관련된 엔터티만 학생 엔터티로 위치를 이동)

3 정규형 : (일반)속성에 종속적인 속성 분리
          일반 속성은 식별자 속성에 종속되어야 하는데, 일반 속성간 종속이 있는 경우를
          분리
          식별 속성 -> 일반 속성 -> 다른 일반 속성
          ==> 이행적 함수 종속성 제거
          

도메인 : 미리 정의한 데이터 타입, 자주 사용하는 데이터 타입을 재활용
집전화번호 02~063 -XYZ(T)-QWER
핸드폰번호 010-XYZT-QWER

집전화번호, 핸드폰번호나 동일한 데이터 타입으로 관리하는게 가능 할거 같음
연락처라는 도메인을 생성(VARCHAR1(30)  
)



학생 정보와 학생이 수강하는 교과목을 관리 하려고 한다

학생 정보로는 학번, 학생이름, 생년월일, 집주소, 핸드폰번호, 집전화번호 를 관리하고

교과목으로는 과목명, 과목번호, 학점, 수강대상학년, 교재정보 관리 하려고 한다

학생은 교과목을 수강하고, 수강이력을 관리해야 한다
    1. 재수강을 허용하지 않는 형태 ㅡ식별
    2. 재수강을 허용하는 형태 ㅡ비식별

1. 엔터티 추출, exerd로 엔터티 정의하기
학생 수강 교과목















