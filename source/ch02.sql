-- 주석
-- 쿼리 설명을 위한 코드(실행되지 않음)
-- 한 줄 주석
# 또 다른 한 줄 주석
/* 
	블록 주석 
    여러 줄 주석
*/

-- 쿼리(query)란? 문의하다, 질문하다 라는 뜻
-- 예: 데이터베이스에 사용자가 원하는 특정 데이터를 보여달라고 요청하는 것
-- 쿼리는 SQL을 이용해 하나의 명령문으로 작성
-- 하나의 쿼리는 하나의 ;(세미콜론) 으로 구분
SELECT 'hello world'; -- 쿼리문이라고 부름

/* (참고) SQL이 제공하는 기본 키워드들은 대소문자를 구분하지 않음
	권장 SQL 작성법은 일반적인 관례에 따라 
    대문자: MYSQL 키워드(예약어)
    소문자: 사용자가 직접 만든 변수(예: 테이블/열(컬럼)이름 )
    
    실문에서는 회사/팀의 룰을 따르면 됨
*/ 

/*
	2. 데이터 생성, 조회, 수정, 삭제하기
    2.1 데이터 CRUD
*/
-- CRUD 란? DB가 제공하는 기본 동작으로 데이터 관리의 가장 핵심적인 기능
-- 생성 (Create) 
-- 조회 (Read)
-- 수정 (Update)
-- 삭제 (Delete)

/*
	2.2 데이터베이스 만들기
*/
-- 데이터베이스 목록 조회하기
SHOW DATABASES;
-- MYSQL 설치 시 기본적으로 깔려있는 시스템 데이터베이스

-- 데이터베이스 생성
-- CREATE DATABASE  데이터베이스이름;
CREATE DATABASE mapdonalds;
    
-- 실무 Tip 
-- 데이터 베이스 이름은 보통 프로젝트 이름이나 서비스 특징을 나타내는 것으로 정함
-- 소문자와 언더스코어(_)를 조합하여 만드는 것이 일반적인 관례 (예: my_shop, shopping_mall_db)

-- 데이터베이스 진입(접속)
-- USE 데이터베이스이름;
USE mapdonalds;

-- 현제 사용 중인 DB조회
SELECT DATABASE();

-- 데이터베이스 삭제
-- DROP DATABASE 데이터베이스 이름;
DROP DATABASE mapdonalds;

-- 주의! DROP 명령어 (특히 DROP DATABASE) 는 함부로 사용하면 안 됨
-- 모든 데이터가 날라가는 돌이킬 수 없는 길을 건너게 됨
-- 삭제 전에는 항상 백업이 되어 있는지, 그리고 정말 삭제해야 하는 대상이 맞는지 확인하는 습관

-- Quiz
-- 1. 다음 설명 중 옳지 않은 것은?
-- ① 데이터 CRUD란 데이터를 생성(Create), 조회(Read), 수정(Update), 삭제(Delete)하는 것을 말한다. 
-- ② 쿼리란 데이터베이스에 내릴 명령을 SQL 문으로 작성한 것이다.
-- ③ 쿼리는 하나의 ;(세미콜론)으로 구분한다.
-- ④ MySQL은 쿼리의 대소문자를 구분한다.
-- ⑤ 주석은 쿼리 실행에 영향을 미치지 않는다.

-- 정답: 4
/* 
	2.3 데이터 삽입 및 조회하기
*/
-- Quiz: 다시 mapdonalds DB 생성 및 진입 

CREATE DATABASE mapdonalds;
USE mapdonalds;

-- 테이블 생성
/* CREATE TABLE 테이블명 (
	컬럼명1 자료형1,
    ... 
	PRIMARY KEY (컬럼명	
);
*/
CREATE TABLE burgers(
	id INTEGER, -- 아이디(정수)
--  id INT PRIMARY KEY  -- 또는 이렇게 써도 가능
    name VARCHAR(50), -- 이름(최대 50글자의 문자)
    -- VARCHAR(n): 문자를 최대 n자리까지 저장( 가변 길이 타입이라 저장될 수 있는 최대 길이의 제한을 알려줘야 함)
    price INTEGER, -- 가격 (정수)
    gram INTEGER, -- 무게(정수)
	kcal INTEGER, -- 열량(정수)
    protein INTEGER, -- 단백질량(정수)
    PRIMARY KEY(id) -- 기본키 지정(필수!)
);

-- 기본키: 레코드(row) 를 대표하는 컬럼 (예: 사람의 주민등록 번호, 학생의 학번, 군인의 군번, 사원의 사번)
-- 테이블에 저장된 모든 버거를 구분하기 위한 컬럼
-- 중복되지 않는 값을 가짐

-- 테이블 구조 조회
-- DESC 테이블명;
DESC burgers; -- burgers 테이블의 구조를 설명해줘
-- Field: 테이블의 컬럼
-- Type: 컬럼의 자료형(int는 INTEGER의 별칭)
-- Null: 컬럼에 빈 값을 넣어도 되는지. 즉, 입력값이 없어도 되는지 여부(기본키는 NO: 반드시 값이 들어가야 함)
-- Key: 대표성을 가진 컬럼(기본키, 외래키, 고유키 등의 특별한 대표성을 가지는지를 의미)
-- Default: 컬럼의 기본값(입력값이 없을 시 설정할 기본값)
-- Extra: 추가 설정(컬럼에 적용된 추가 속성)
SHOW TABLES;

-- (참고) 테이블 변경하기
-- ALTER TABLE: 이미 만든 테이블의 구조 변경
-- 예: 포인트 제도가 새로 생겨서 고객 테이블에 point 열을 추가해야 할 때

-- 열(column) 추가하기 - ADD COLUMN 
-- burgers 테이블에 set_price( 세트 메뉴 가격) 컬럼 추가
ALTER TABLE burgers
ADD COLUMN set_price INT NOT NULL DEFAULT 0; 

-- 열(column) 데이터 타입 변경하기 - MODIFY COLUMN
-- burgers 테이블의 name 컬럼을 더 킬게 만들어야 한다면?
ALTER TABLE burgers
MODIFY COLUMN name VARCHAR(100);

-- 열 (column) 삭제하기 - DROP COLUMN 
-- set_price (세트 메뉴 가격) 컬럼 제거
ALTER TABLE burgers
DROP COLUMN set_price;

DESCRIBE burgers;

-- 주의! ALTER TABLE 은 유용한 기능이지만, 조심해서 사용해야 함
-- 수백만, 수천만 건의 데이터가 들어 있는 거대한 테이블의 구조를 변경하는 작업은 많은 시간과 시스템 자원을 소모
-- 작업 중에는 테이블이 잠겨서 서비스가 일시적으로 멈출 수도 있음
-- 따라서 실무에서는 사용자가 적은 새벽 시간을 이용해 점검 시간에 맞춰 작업하는 것이 일반적

-- 단일 데이터 삽입하기 
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2, ...)
-- VALUES (입력값1, 입력값2, ... );

-- 컬럼 순서와 개수에 맞게 값 입력
INSERT INTO burgers (id, name, price, gram, kcal, protein)
VALUES (1, '빅맨', 5300, 223, 583, 27);

-- 데이터 조회하기
/*
SELECT 컬럼명1, 컬럼명2, ... -- 조회할 컬럼( 컬럼명 대신 * 을 쓰면
FROM 테이블명
WHERE 조건; -- 검색 조건( 생략하면 전체 조회)
*/

-- burgers 테이블의 모든 컬럼 조회
SELECT * 
FROM burgers;

-- 컬럼 생략 가능? 가능하지만 테이블 정의에 맞게 모든 열에 순서대로 값을 넣어야 함
INSERT INTO burgers 
VALUES (2, '빅맥', 5300, 223, 583, 27);

-- 데이터를 넣지 않으면 NULL이 들어감
INSERT INTO burgers (id, name, gram, kcal)
VALUES (3, '빅맨', 233, 583);

-- 테이블의 몬든 데이터 삭제
TRUNCATE TABLE burgers;

-- 다중 데이터 삽입하기
INSERT INTO 
	burgers (id, name, price, gram, kcal, protein)
VALUES 
	(1, '빅맨', 5300, 223, 583, 27),
    (2, '베이컨 틈메이러 디럭스', 6200, 242, 545, 27),
	(3, '맨스파이시 상하이 버거', 5300, 235, 494, 20),
	(4, '슈비두밥 버거', 6200, 269, 563, 21),
	(5, '더블 쿼터파운드 치즈', 7700, 275, 770, 50);
    
-- burgers 테이블의 이름과 가격만 조회
SELECT name, price 
FROM burgers;

-- 실무에서는 SELECT * 사용을 최소화하고, 꼭 필요한 열만 명시적으로 지정해서 조회!
-- why? 조회 성능 저하, 가독성 저하, 네트워크 트래픽 낭비 등

-- Quiz
-- 2. 다음 빈칸에 들어갈 용어를 순서대로 고르면? (입력 예: ㄱㄴㄷㄹㅁ)
-- ① __________: 테이블을 만드는 SQL 문
-- ② __________: 정수형 숫자(-1, 0. 1, )를 저장하기 위한 자료형
-- ③ __________: 문자를 저장하기 위한 자료형(최대 길이 지정 가능)
-- ④ __________: 테이블에 데이터를 삽입하는 SQL 문
-- ⑤ __________: 테이블의 데이터를 조회하는 SQL 문

-- (ㄱ) INSERT INTO 문
-- (ㄴ) CREATE TABLE 문
-- (ㄷ) INTEGER
-- (ㄹ) VARCHAR
-- (ㅁ) SELECT 문

-- 정답: ㄴ, ㄷ, ㄹ, ㄱ, ㅁ

/*
	2.4 데이터 수정 및 삭제하기
*/
-- 데이터 수정하기: UPDATE
-- UPDATE 테이블명
-- SET 컬럼명1 = 입력값1, 컬럼명2 = 입력값2, ... -- 어떤 컬럼에 어떤 값을 입력할지
-- WHERE 조건; -- 수정 대상을 찾는 조건(주의! 생략하면 전체 대상)

-- 모든 버거의 가격을 1000 으로 수정
UPDATE burgers
SET price = 1000;
-- 에러 발생: 워크벤치의 기본 세팅 때문에 발생
-- 모든 값을 일괄적으로 변경하는 것을 클라이언트에서 막고 있음
-- 에러 메시지 확인 : 언전 모드에서는 KEY 없는 UPDATE/DELETE를 차단함

-- 안전 모드 설정 확인
SELECT @@sql_safe_updates; -- 0: 해제, 1: 설정

-- 임시로 안전모드 해제( 권장안함 ) 
SET SQL_SAFE_UPDATES = 0;

-- 전체 버거 조회
SELECT * FROM burgers;

-- 안전모드 재설정
SET SQL_SAFE_UPDATES = 1;

-- 특정(단일) 레코드 수정하기
-- 빅맥 버거만 가격을 500 으로 수정
UPDATE burgers 
SET price = 500
where name = '빅맨';-- 특정 대상 변경시, 조건은 반드시 기본키를 사용
-- 안전모드에서는 KEY 컬럼이 아닌 다른 값을 사용하면 막음

-- 수정 대상 조건 개선: 키를 통한 변경 쿼리
UPDATE burgers 
SET price = 500
where id = 1;

-- 데이터 삭제하기: DELETE
/*
DELETE FROM 테이블명
WHERE 조건; -- 삭제 대상을 찾는 조건
*/

-- ' 수비두밥 버거' 가 단종됐다면, 이를 위한 데이터 삭제 쿼리는
DELETE FROM burgers
WHERE id = 4;

UPDATE burgers 
SET id = 4
WHERE id = 5;

-- 테이블 삭제하기
-- 테이블 속 데이터 뿐만 아니라, 테이블 자체를 삭제하는 방법은?
-- DROP  TABLE 테이블명;

DROP TABLE burgers;

DESC burgers;
SELECT * FROM burgers;

-- Quiz
-- 3. 다음 설명에 대한 용어를 고르면? (입력 예: ㄱㄴㄷㄹㅁ)
-- ① 테이블의 데이터를 수정하는 SQL 문
-- ② 특정조건을 만족하는 튜플을 조회하는 SQL 문
-- ③ 테이블의 데이터를 튜플 단위로 삭제하는 SQL 문
-- ④ 테이블 자체를 삭제하는 SQL 문
-- ⑤ 데이터베이스 자체를 삭제하는 SQL 문

-- (ㄱ) DELETE 문
-- (ᄂ) DROP TABLE 문
-- (ᄃ) UPDATE 문
-- (ᄅ) SELECT 문
-- (ᄆ) DROP DATABASE 문

-- 정답:ㄷㄹㄱㄴㅁ

-- (참고) DROP TABLE vs TRUNCATE TABLE
-- 테이블을 다루다 보면 테이블의 내용을 비워야 할 때가 있음

-- DROP TABLE: 테이블의 존재 자체를 삭제
-- DROP TABLE burgers; 를 실행하면, burgers 테이블의 모든 데이터는 물론, burgers 라는 테이블의 구조까지 완전히 사라짐
-- 테이블을 다시 사용하려면 CREATE TABLE 부터 다시 해야 함(마치 건물을 통째로 철거하는 것과 같음)

-- TRUNCATE TABLE: 테이블의 구조는 남기고, 내부 데이터만 모두 삭제
-- TRUNCATE TABLE burgers; 를 실행하면, burgers 테이블 안의 모든 데이터가 순식간에 사라짐
-- 하지만 burgers 라는 테이블의 구조(열, 제약조건 등)는 그대로 남아있어서, 바로 새로운 데이터를 INSERT 할 수 있음(건물의 내부만 싹 비우고 뼈대는 그대로 두는 것과 같음)

-- 정리: 
-- 테스트 데이터를 모두 지우고 처음부터 다시 시작하고 싶을 때는 TRUNCATE 가 유용하고, 
-- 테이블 자체가 더 이상 필요 없을 때는 DROP 을 사용

-- (추가 설명) DELETE vs TRUNCATE
-- DELETE FROM burgers; (WHERE 절 없는 DELETE)와 결과적으로는 같아 보이지만, TRUNCATE 가 훨씬 빠름
-- DELETE 는 한 줄씩 지우면서 삭제 기록을 남기는 반면, TRUNCATE 는 테이블을 초기화하는 개념이라 내부 처리 방식이 더 간단하고 빠름
-- TRUNCATE 는 AUTO_INCREMENT 값도 초기화
-- 만약 burgers 테이블에 1000개의 데이터가 있어서 다음 id가 1001일 차례였다면, TRUNCATE 이후에는 다시 1부터 시작(DELETE는 AUTO_INCREMENT 값을 초기화하지 않는다.)

-- 정리: 
-- "탈퇴한 회원 한 명의 정보만 지우고 싶다" 또는 "특정 조건에 맞는 주문 기록만 삭제하고 싶다" 와 같이 선별적인 삭제가 필요할 때는 DELETE를 사용(일반적인 비즈니스 로직은 항상 DELETE를 사용)
-- "테스트용으로 넣었던 수백만 건의 데이터를 모두 지우고 처음부터 다시 시작하고 싶다" 와 같이 테이블의 모든 데이터를 깨끗하게 비울 목적이라면 TRUNCATE가 훨씬 빠르고 효율적








