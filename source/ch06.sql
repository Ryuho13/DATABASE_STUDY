/*
	6. 관계 만들기
	6.1 관계란
*/
-- 무엇? 여러 테이블에 분산된 데이터가 어떻게 서로 연결돼 있는지를 나타내는 것
-- 테이블: 서로 관련 있는 데이터를 묶은 것
-- 관계: 여러 테이블에 흩어져 있는 데이터 간 연결고리
-- 관계의 유형 3가지
-- - 일대일(1:1)
-- - 일대다(1:N)
-- - 다대다(N:M)

-- 1. 일대일 관계(1:1, one-to-one)
-- 하나의 데이터가 다른 한 데이터와만 연결된 관계
-- 예: 사용자-개인 설정, 나라-수도, 사람-주민등록증
-- 하나의 테이블로 만들어도 되지만 테이블을 나눴을 때 이점이 있거나, 컬럼이 너무 많아져서 나눌 필요가 있을 때

-- 2. 일대다 관계(1:N, one-to-many)
-- 하나의 데이터가 여러 데이터와 연결된 관계
-- 포함 또는 소유의 관계
-- 예: 사진-댓글, 부서-직원

-- 3. 다대다 관계(N:M, many-to-many)
-- 여러 데이터가 여러 데이터와 연결된 관계('연결 고리' 필요)
-- 예: 
-- 1) 학생-과목
-- 한 학생이 여러 과목 수강 가능
-- 한 과목은 여러 학생을 수용 가능
-- 2) 사용자-사진
-- 한 사용자가 여러 사진에 좋아요 가능
-- 한 사진은 여러 사용자로부터 좋아요 가능

-- 다대다(N:M)는 사실상 직접 표현할 수 없기 때문에, 두 개의 일대다 관계로 분해해서 처리
-- 학생(1)-(N)수강등록(M)-(1)과목
-- 사용자(1)-(N)좋아요(M)-(1)사진
-- 여기서 '수강등록', '좋아요'는 연결 고리(=중간 테이블)가 된다.


-- 테이블 간 관계는 어떻게 만들어질까?
-- 관계를 만드는 키가 존재
-- => 기본키와 외래키의 연결을 통해 만들어짐

-- 기본키(PK, Primary Key)
-- 테이블의 각 행을 고유하게 식별할 수 있는 컬럼
-- 레코드를 구분하는 "컬럼" 또는 "컬럼의 조합"을 말함
-- 예: 주민등록번호
-- 모든 테이블에는 반드시 PK가 존재

-- 다음 4가지 특징을 만족해야 함
-- - 유일성: 유일한 값을 가져야 함(=UNIQUE 제약 조건)
-- - 비 널: NULL이 올 수 없고, 반드시 값을 가져야 함(=NOT NULL 제약 조건)
-- - 불변성: 한 번 정해진 값은 바뀔 수 없음
-- - 식별성: 레코드를 구분하는 명확한 기준 역할을 해야 함

-- 실무에서는 보통 기본키는 id로 명명
-- 예: 고객 테이블은 customer_id, 상품 테이블은 product_id와 같이 테이블명_id 형식으로 이름을 짓는 것이 일반적인 관례
-- 1부터 시작하여 데이터가 추가될 때마다 1씩 자동으로 증가하는 정수값(INTEGER)을 기본키로 사용하는 경우가 가장 흔함


-- 외래키(FK, Foreign Key)
-- 다른 테이블의 기본키를 가리키는 컬럼
-- 두 테이블을 관계로 묶어 연결하는 역할
-- 예: 고객 테이블(PK: customer_id, 참조 당하는 쪽, 부모 테이블) <--(참조)-- 주문 테이블(FK: customer_id, 참조 하는 쪽, 자식 테이블)

-- "참조 무결성"을 강제함(두 테이블의 관계가 항상 유효하고 일관된 상태를 유지해야 한다는 원칙)
-- 쉽게 말하면 참조하는 값이 무조건 있어야 함
-- 예: 고객 테이블에 customer_id(PK)가 1~3까지 저장되어 있는데 
-- 주문 테이블에 customer_id(FK) 값이 99가 입력된다면(고객 테이블에는 99번 고객 아이디가 없음) 
-- 데이터베이스는 데이터의 입력을 막음(오류 발생)


-- 그 외 제약 조건
-- 제약 조건: 컬럼 생성 시 부여하는 특성으로 저장할 수 있는 값에 제한이나 규칙을 설정
-- 이로 인해 잘못되거나 일관성 없는 데이터가 입력되는 것을 원천적으로 차단할 수 있음
-- 데이터의 무결성(정확성, 일관성, 유효성을 유지하려는 성질), 즉 데이터에 결점이 없는 상태를 유지하는 것이 제약 조건의 핵심 목표

-- - AUTO_INCREMENT: 컬럼의 값을 1씩 자동 증가하여 저장(정수형에 붙일 수 있으며 기본키와 함께 사용됨)
-- - UNIQUE: 컬럼에 값이 고유하도록 강제(중복 값을 입력하면 에러), 예: 이미 사용 중인 이메일입니다.
-- - NOT NULL: 필수 값, 컬럼에 반드시 값이 입력되어야 함(값을 입력하지 않으면, 즉 NULL 값이 들어가면 에러)
-- - DEFAULT: 컬럼에 입력값이 없을 시, 기본값을 부여, 예: 처음 회원 가입 시 사용자의 포인트 = 0
-- - CHECK: 컬럼에 들어갈 수 있는 값의 범위나 조건을 직접 지정, 반드시 만족하도록 강제(조건을 만족하지 않는 값 입력 시 에러), 예: 반드시 짝수
-- - UNSIGNED: 숫자형 컬럼에 음수 허용을 금지(양수값만 저장하도록 제한)

-- 제약 조건의 사용 예
CREATE TABLE users (
	id INT AUTO_INCREMENT,               -- 아이디(자동으로 1씩 증가)
    email VARCHAR(100) UNIQUE,           -- 이메일(고유한 값만 허용)
    name VARCHAR(50) NOT NULL,           -- 사용자명(NULL을 허용하지 않음)
    status VARCHAR(10) DEFAULT 'active', -- 계좌 상태(기본값은 'active')
    balance INT UNSIGNED,                -- 계좌 잔액(음수를 허용하지 않음)
    age INT CHECK (age >= 18),           -- 나이(18세 이상만 허용)
    PRIMARY KEY (id)                     -- 기본키 지정: id
);

-- 제약 조건 위반 시 테스트
-- 사용자명(NOT NULL)에 NULL 값을 입력 시도
INSERT INTO users (email, name)
VALUES ('geoblo@naver.com', NULL);
-- Error Code: 1048. Column 'name' cannot be null

-- 이메일(UNIQUE)에 중복 값을 입력 시도
INSERT INTO users (email, name)
VALUES ('geoblo@naver.com', '김');

INSERT INTO users (email, name)
VALUES ('geoblo@naver.com', '재');
-- Error Code: 1062. Duplicate entry 'geoblo@naver.com' for key 'users.email'

-- 기본키(PK)에 중복 값을 입력 시도
INSERT INTO users (id, email, name)
VALUES (1, 'hyun@naver.com', '현');
-- Error Code: 1062. Duplicate entry '1' for key 'users.PRIMARY'

-- 나이(age >= 18)에 18세 미만 값을 입력 시도
INSERT INTO users (email, name, age)
VALUES ('hyun@naver.com', '현', 15);
-- Error Code: 3819. Check constraint 'users_chk_1' is violated.

-- Quiz: 제약 조건 걸기
CREATE TABLE products (
  id INTEGER AUTO_INCREMENT,                 -- 상품 ID(자동 증가)
  name VARCHAR(100) UNIQUE,                  -- 상품명(고유한 값만 허용)
  category VARCHAR(50) NOT NULL,             -- 상품 카테고리(NULL 불가)
  status VARCHAR(20) DEFAULT 'available',    -- 상품 상태(기본값: available)
  dc_rate INTEGER (dc_rate BETWEEN 0 AND 50),-- 할인율(0~50% 제한)
  -- dc_rate INTEGER (dc_rate >= 0 AND dc_rate <= 50)
  stock INTEGER UNSIGNED,                    -- 재고 수량(음수 불가)
  PRIMARY KEY (id)                           -- 기본키 설정: id
);

-- (참고) Tip! 날짜와 기본값 설정 옵션
CREATE TABLE boards (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 이 기능을 사용하면 행이 추가되거나 변경될 때 날짜를 편리하게 관리할 수 있음
-- DEFAULT CURRENT_TIMESTAMP: 새로운 데이터 행이 추가될 때, 
-- 해당 컬럼에 별도의 값을 지정하지 않으면 현재 날짜와 시간이 자동으로 입력됨
-- DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP: 새로운 데이터 행이 추가될 때는 물론이고,
-- 같은 행의 컬럼 값이 변경되어 업데이트될 때, 현재 날짜와 시간으로 자동 갱신됨


-- Quiz
-- 1. 다음 빈칸에 들어갈 용어를 순서대로 고르세요. (예: ㄱㄴㄷㄹㅁ)
-- ① __________: 여러 테이블에 분산 저장된 데이터가 서로 어떻게 연결돼 있는지를 정의한 개념
-- ② __________: 테이블 내 모든 튜플을 유일하게 구분하는 칼럼 또는 칼럼의 조합
-- ③ __________: 한 번 설정된 값은 변경될 수 없다는 성질
-- ④ __________: 데이터가 존재하지 않는 상태
-- ⑤ __________: 다른 테이블의 기본키를 가리키는 칼럼으로 두 테이블 간 관계를 만드는 칼럼

-- (ㄱ) 불변성
-- (ㄴ) 관계
-- (ㄷ) 외래키(FK)
-- (ㄹ) NULL
-- (ㅁ) 기본키(PK)

-- 정답: ㄴㅁㄱㄹㄷ 


/*
	6.2 다양한 관계 만들기
*/
-- 외래키와 기본키를 연결하여 일대일/일대다/다대다 관계를 만들어 보자

-- 외래키 제약 조건의 문법
-- CONSTRAINT [제약조건_이름] 
-- FOREIGN KEY ([자식_테이블의_컬럼명]) 
-- REFERENCES [부모_테이블명]([부모_테이블의_컬럼명])
-- [ON DELETE 옵션] [ON UPDATE 옵션]

-- (참고) ON DELETE / ON UPDATE 옵션
-- 데이터베이스가 부모 데이터의 삭제나 수정을 무조건 막는 것이 기본값(RESTRICT)이며 가장 안전한 정책
-- 하지만 상황에 따라 다른 정책이 필요할 수 있음 
-- 예를 들어 회원이 탈퇴하면, 그 회원의 모든 작성 글, 주문 기록 등이 함께 삭제되어야 할 때
-- 이럴 때 사용하는 것이 외래키의 ON DELETE 와 ON UPDATE 옵션
-- RESTRICT(기본값): 자식 테이블에 참조하는 행이 있으면 부모 테이블의 행을 삭제/수정할 수 없다.
-- CASCADE: 부모 테이블의 행이 삭제/수정되면, 그를 참조하는 자식 테이블의 행도 함께 자동으로 삭제/수정된다.
-- SET NULL: 부모 테이블의 행이 삭제/수정되면, 자식 테이블의 해당 외래 키 컬럼의 값을 NULL로 설정한다.
-- (단, 이 옵션을 쓰려면 자식 테이블의 외래 키 컬럼이 NULL을 허용해야 함)

-- 실무에서는 CASCADE 옵션을 잘못 사용할 경우 예상치 못한 대량의 데이터가 함께 삭제되는 경우가 있음
-- 특히 관계가 복잡하게 얽혀 있는 경우에는 파급 효과를 예측하기 어려움
-- 이런 문제로 실무에서는 CASCADE 옵션은 잘 사용하지 않고 대신에 애플리케이션 계층에서 명시적으로 관련된 데이터를 처리하는 방식이 더 선호됨
-- 즉, 애플리케이션에서 부모 데이터를 지울 때 자식 데이터를 먼저 찾아 지우도록 코드를 작성


-- 1. 일대일 관계 만들기
-- A 테이블의 한 데이터가 B 테이블의 한 데이터와만 연결된 관계
-- 서로 긴밀한 연관성이 있거나, 하나의 테이블에서 분화된 경우의 관계
-- 일대일 관계에서 외래키의 위치는 양쪽 테이블 중 어느 곳에 두어도 되지만 사용 빈도가 더 적은 쪽에 두는 것이 일반적임

-- relation DB 생성 및 진입
CREATE DATABASE relation;
USE relation;

-- countries 테이블 생성
CREATE TABLE countries (
	id INT,
    name VARCHAR(255), -- 국가명
    PRIMARY KEY (id)
);

-- capitals 테이블 생성
CREATE TABLE capitals (
	id INT,
    name VARCHAR(255), -- 수도명
    country_id INT UNIQUE, -- 국가 아이디(수도가 속한 나라)
    -- 타입은 국가 테이블과 동일하게 맞춤
    -- 고유한 값만 허용(한 나라에 수도가 2개 이상일 수 없음) => UNIQUE: 일대일 관계를 만들기 위한 중요한 제약 조건
    PRIMARY KEY (id),
    FOREIGN KEY (country_id) REFERENCES countries(id)
    -- country_id 외래키는 countries 테이블의 id 컬럼을 가르킨다는 의미(참조)
);

-- (참고) 실무에서는 보통 명시적으로 CONSTRAINT 이름을 주는 것을 권장(유지보수, 디버깅 편리)
-- CONSTRAINT fk_capitals_countries FOREIGN KEY (country_id) REFERENCES countries(id)

DESC countries;
DESC capitals;

-- countries 데이터 삽입
INSERT INTO countries (id, name)
VALUES
	(1, 'South Korea'),
	(2, 'United States'),
	(3, 'Japan');

-- capitals 데이터 삽입
INSERT INTO capitals (id, name, country_id)
VALUES
	(101, 'Seoul', 1),
	(102, 'Washington D.C.', 2),
	(103, 'Tokyo', 3);

-- 확인
SELECT * FROM countries;
SELECT * FROM capitals;

-- 참조 무결성 위반 시 테스트
INSERT INTO capitals (id, name, country_id)
VALUES (104, 'Paris', 999); -- 999는 부모 테이블에 없는 id
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`relation`.`capitals`, CONSTRAINT `capitals_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`))

DELETE FROM countries
WHERE id = 1; -- 이 나라를 참조하는 수도(자식 테이블)가 있기 때문에 삭제 불가
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`relation`.`capitals`, CONSTRAINT `capitals_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`))
-- 이 경우에는 자식 테이블에 참조하는 데이터를 모두 삭제하고 부모 테이블에서 삭제하면 가능


-- 2. 일대다 관계 만들기
-- A 테이블의 한 데이터가 B 테이블의 여러 데이터와 연결되는 관계
-- 하나의 데이터에 여러 데이터가 포함되거나 소유되는 경우
-- 일대다 관계에서는 '다' 쪽 테이블에 외래키 지정

-- teams 테이블
CREATE TABLE teams (
	id INT,
    name VARCHAR(255), -- 팀명
    PRIMARY KEY (id)
);

-- players 테이블
CREATE TABLE players (
	id INT,
    name VARCHAR(255), -- 선수명
    team_id INT, -- 소속팀 아이디, 일대다 관계에서는 UNIQUE 제약 조건 X
    PRIMARY KEY (id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
    -- teams 테이블의 id 컬럼을 가르킴 => 선수가 어느 팀에 소속되어 있는지를 연결(관계 형성)
);

DESC teams;
DESC players;

-- teams 데이터 등록
INSERT INTO teams (id, name)
VALUES
	(1, 'FC Awesome'),
	(2, 'Winners United');

-- players 데이터 등록
INSERT INTO players (id, name, team_id)
VALUES
	(1, 'John Doe', 1),
	(2, 'Jane Smith', 1),
	(3, 'Max Payne', 2),
	(4, 'Alex Johnson', 2),
	(5, 'Sara Connor', 2);

-- 확인
SELECT * FROM teams;
SELECT * FROM players;

-- 3. 다대다 관계 만들기
-- A와 B 테이블 서로가 다수의 데이터와 연결되는 관계
-- - A 테이블의 한 데이터가 B 테이블의 여러 데이터와 연결
-- - B 테이블의 한 데이터 또한 A 테이블의 여러 데이터와 연결
-- 중간 테이블을 경유하여 A와 B가 연결됨
-- 다대다 관계에서는 중간 테이블을 만들어 외래키 지정

-- doctors 테이블
CREATE TABLE doctors (
	id INT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

-- patients 테이블
CREATE TABLE patients (
	id INT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

-- appointments 테이블
CREATE TABLE appointments (
	id INT,
    doctor_id INT, -- 의사 아이디
    patient_id INT, -- 환자 아이디
    date DATE, -- 진료 일자
    PRIMARY KEY (id), 
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

DESC appointments;

-- doctors 데이터 삽입
INSERT INTO doctors (id, name)
VALUES
	(1, '김 닥터'),
	(2, '이 닥터'),
	(3, '최 닥터');

-- patients 데이터 삽입
INSERT INTO patients (id, name)
VALUES
	(1, '환자 A'),
	(2, '환자 B'),
	(3, '환자 C');

-- appointments 데이터 삽입
INSERT INTO appointments (id, doctor_id, patient_id, date)
VALUES
	(1, 1, 1, '2025-01-01'),
	(2, 1, 2, '2025-01-02'),
	(3, 2, 2, '2025-01-03'),
	(4, 2, 3, '2025-01-04'),
	(5, 3, 3, '2025-01-05'),
	(6, 3, 1, '2025-01-06');

-- 확인
SELECT * FROM doctors;
SELECT * FROM patients;
SELECT * FROM appointments;

-- Quiz: 관계 맺기
-- 1. 사람과 여권(한 사람은 한 개의 여권을 가지고, 한 여권은 한 사람에게만 발급)
-- 사람 테이블
CREATE TABLE persons (
  id INTEGER,        -- ID
  name VARCHAR(50),  -- 이름
  PRIMARY KEY (id)  -- 기본키 지정: id
);

-- 여권 테이블
CREATE TABLE passports (
  id INTEGER,                  -- ID
  passport_number VARCHAR(20), -- 여권 번호
  person_id INTEGER UNIQUE,    -- 사람_ID
  PRIMARY KEY (id),          -- 기본키 지정: id
  FOREIGN KEY (person_id) REFERENCES persons(id) -- 외래키 지정: person_id
);

-- 2. 회사와 직원(한 회사는 여러 직원을 고용할 수 있지만, 한 직원은 하나의 회사에만 소속)
-- 회사 테이블
CREATE TABLE companies (
  id INTEGER,       -- ID
  name VARCHAR(50), -- 회사명
  PRIMARY KEY (id)  -- 기본키 지정: id
);

-- 직원 테이블
CREATE TABLE employees (
  id INTEGER,             -- ID
  name VARCHAR(50),       -- 직원명
  company_id INTEGER,     -- 회사_ID
  PRIMARY KEY (id),      -- 기본키 지정: id
  FOREIGN KEY (company_id) REFERENCES companies(id) -- 외래키 지정: company_id
);

-- 3. 학생과 과목(한 학생은 여러 과목을 수강하고, 한 과목은 여러 학생이 수강할 수 있음)
-- 학생 테이블
CREATE TABLE students (
  id INTEGER,          -- ID
  name VARCHAR(50),    -- 학생명
  PRIMARY KEY (id)    -- 기본키 지정: id
);

-- 과목 테이블
CREATE TABLE subjects (
  id INTEGER,        -- ID
  title VARCHAR(50), -- 과목명
  PRIMARY KEY (id)    -- 기본키 지정: id
);

-- 수강 테이블(중간 테이블)
CREATE TABLE enrollments (
  id INTEGER,          -- ID
  student_id INTEGER,  -- 학생_ID
  subject_id INTEGER,  -- 과목_ID
  PRIMARY KEY (id),    -- 기본키 지정: id
  FOREIGN KEY (student_id) REFERENCES students(id), -- 외래키 지정: student_id 
  FOREIGN KEY (subject_id) REFERENCES subjects(id)  -- 외래키 지정: subject_id 
);

-- Quiz
-- 2. 다음 세 테이블에 대한 설명으로 맞으면 O, 틀리면 X를 표시하시오.

-- doctors
-- id | name
-- ------------
-- 1  | 김 닥터
-- 2  | 이 닥터
-- 3  | 최 닥터

-- patients
-- id | name
-- ------------
-- 1  | 환자 A
-- 2  | 환자 B
-- 3  | 환자 C

-- appointments
-- id | doctor_id  | patient_id  | date
-- -------------------------------------------
-- 1  | 1          | 1           | 2025-01-01
-- 2  | 1          | 2           | 2025-01-02
-- 3  | 2          | 2           | 2025-01-03
-- 4  | 2          | 3           | 2025-01-04
-- 5  | 3          | 3           | 2025-01-05
-- 6  | 3          | 1           | 2025-01-06

-- ① '김 닥터'는 '환자 A'를 진료했다. (  )
-- ② '이 닥터'는 3회의 진료 기록이 있다. (  )
-- ③ '환자 C'는 '최 닥터'에게 진료를 받았다. (  )

-- 정답: O, X, O

-- 3. 다음 설명이 맞으면 O, 틀리면 X를 표시하시오.
-- ① 두 테이블 간 일대일 관계는 어느 쪽에 외래키를 지정해도 무방하나 대게 테이블의 사용 빈도가 적은 쪽에 지정한다. 
-- 또한 외래키 컬럼을 선언할 때 UNIQUE 제약 조건을 설정한다. (  )
-- ② 두 테이블 간 일대다 관계는 '일' 쪽 테이블에 외래키를 지정한다. (  )
-- ③ 두 테이블 간 다대다 관계는 중간 테이블을 만들어 두 테이블의 기본키를 참조하도록 외래키를 지정한다. (  )

-- 정답: O, X, O


/*
	6.3 관계 만들기 실습: 별그램 DB
*/
-- 사진 공유 SNS, 별그램 DB를 만들며 다양한 관계 생성 훈련!

-- 별그램 DB의 테이블 개요
-- • users(사용자): 사용자의 '아이디', '닉네임, '이메일'을 저장합니다.
-- • photos(사진): 사진의 '아이디', '파일명', '게시자 아이디'를 저장합니다.
-- • comments(댓글): 댓글의 '아이디', '본문', 작성자 아이디', '댓글이 달린 사진 아이디'를 저장합니다.
-- • settings(개인 설정): 사용자 개인 설정의 '아이디, '계정 공개 여부', '계정 추천 여부', '사용자 아이디'를 저장합니다.
-- • likes(좋아요): 좋아요의 '아이디', '좋아요를 누른 사용자 아이디', '좋아요를 받은 사진 아이디'를 저장합니다.

-- 5개의 테이블은 다음과 같은 관계를 가짐
-- • 일대일 관계: '사용자'는 개인별로 하나의 '개인 설정' 값만 가질 수 있습니다.
-- • 일대다 관계: '사용자'는 여러 장의 '사진'을 게시할 수 있습니다.
-- • 다대다 관계:
-- - '사용자'는 여러 '사진'에 댓글을 작성할 수 있고, '사진' 또한 여러 '사용자'로부터 댓글을 받을 수 있습니다.
-- - '사용자'는 여러 '사진'에 좋아요를 누를 수 있고, '사진' 또한 여러 '사용자'로부터 좋아요를 받을 수 있습니다.

-- stargram DB 생성 및 진입
CREATE DATABASE stargram;
USE stargram;

-- 1. 사용자 테이블 만들기
CREATE TABLE users (
	id INT AUTO_INCREMENT,
    nickname VARCHAR(30),
    email VARCHAR(255) UNIQUE,
    PRIMARY KEY (id)
);

-- 2. 사진 테이블 만들기
CREATE TABLE photos (
	id INT AUTO_INCREMENT,
    filename VARCHAR(255) NOT NULL,
    user_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3. 댓글 테이블 만들기
CREATE TABLE comments (
	id INT AUTO_INCREMENT,
    body VARCHAR(1000),
    user_id INT,
    photo_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

-- 4. 개인 설정 테이블 만들기
CREATE TABLE settings (
	id INT AUTO_INCREMENT,
    private BOOLEAN NOT NULL,
    account_suggestions BOOLEAN NOT NULL,
    user_id INT UNIQUE, -- 1:1 연결을 위해 UNIQUE 지정
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. 좋아요 테이블 만들기
CREATE TABLE likes (
	id INT AUTO_INCREMENT,
    user_id INT,
    photo_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

-- users 데이터 삽입(id는 자동 증가값으로 입력되므로 생략)
INSERT INTO users (nickname, email)
VALUES
	('홍팍', 'sehongpark@cloudstudying.kr'),
	('길벗', 'gilbut@cloudstudying.kr'),
	('해삼', 'haesamq@cloudstudying.kr');

-- 데이터 조회
SELECT *
FROM users;

-- photos 데이터 삽입
INSERT INTO photos (filename, user_id)
VALUES
	-- 1번 사용자가 게시한 사진
	('길고양이.jpg', 1),
	('일몰.jpg', 1),
	('은하계.jpg', 1),
	-- 2번 사용자가 게시한 사진
	('백호.jpg', 2),
	('검은 고양이 네로.jpg', 2),
	-- 사용자가 등록되지 않은 사진
	('삭제된 이미지.jpg', NULL),
	('제한된 이미지.jpg', NULL);

-- 데이터 조회
SELECT *
FROM photos;

-- comments 데이터 삽입
INSERT INTO comments (body, user_id, photo_id)
VALUES
	-- 1번 사진에 달린 댓글
	('미야옹~', 1, 1),
	('냐옹!', 2, 1),
	('냥냥~', 3, 1),
	-- 2번 사진에 달린 댓글
	('일몰이 멋지네요', 1, 2),
	('해가 바다로 스윽~', 2, 2),
	-- 3번 사진에 달린 댓글
	('안드로메다 성운인가?', 1, 3),
	('성운이 아니라 은하임', 3, 3),
	-- 대상 사진이 없는 댓글
	('와우~', 3, NULL),
	('오우야~', 3, NULL);

-- 데이터 조회
SELECT *
FROM comments;

DELETE FROM photos
WHERE id IN (8,9,10,11,12,13,14);


-- settings 데이터 삽입
INSERT INTO settings (private, account_suggestions, user_id)
VALUES
	(FALSE, FALSE, 1), 	-- 1번 사용자(비공개 계정, 계정 추천 불가)
	(FALSE, TRUE, 2), 	-- 2번 사용자(비공개 계정, 계정 추천 허용)
	(TRUE, TRUE, 3); 	-- 3번 사용자(공개 계정, 계정 추천 허용)

-- 데이터 조회
SELECT *
FROM settings;

-- likes 데이터 삽입
INSERT INTO likes (user_id, photo_id)
VALUES
	-- 1번 사진에 달린 좋아요: 1, 2번 사용자가 누름
	(1, 1),
	(2, 1),
	-- 2번 사진에 달린 좋아요: 1, 2, 3번 사용자가 누름
	(1, 2),
	(2, 2),
	(3, 2),
	-- 3번 사진에 달린 좋아요: 1, 3번 사용자가 누름
	(1, 3),
	(3, 3),
	-- 6번 사진에 달린 좋아요, 사용자 미등록(탈퇴?, 영정?)
	(NULL, 6),
	-- 7번 사진에 달린 좋아요: 사용자 미등록
	(NULL, 7);

-- 데이터 조회
SELECT *
FROM likes;

-- Quiz
-- 4. 다음 빈칸에 들어갈 용어를 고르시오. (예: ㄱㄴㄷㄹㅁ)
-- ① __________: 컬럼 값이 1씩 증가하며 자동으로 입력되도록 하는 제약 조건
-- ② __________: 컬럼에 값이 반드시 입력되도록 강제하는 제약 조건
-- ③ __________: 두 테이블 간에 다대다 관계를 맺기 위해 필요한 테이블
-- ④ __________: 참 또는 거짓을 저장하기 위한 자료형
-- ⑤ __________: 컬럼의 값이 중복되지 않고 고유한 값만 가지게 하는 제약 조건

-- (ㄱ) BOOLEAN
-- (ㄴ) NOT NULL
-- (ㄷ) 중간 테이블
-- (ㄹ) UNIQUE
-- (ㅁ) AUTO_INCREMENT

-- 정답: ㅁㄴㄷㄱㄹ 

