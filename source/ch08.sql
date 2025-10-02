/*
	8. 그룹화 분석하기
	8.1 그룹화란
*/
-- 그룹화: 데이터를 특정 기준에 따라 나누는 것
-- 그룹화 분석: 그룹별 데이터를 요약하거나 분석하는 것
-- 예: 전체 학생의 평균 키도 의미가 있으나, '성별'로 나누어 평균키를 구하면 조금 더 유의미한 정보를 얻음
-- 또는 어떤 상품 카테고리가 가장 인기가 많은지 '카테고리별' 주문 건수, '카테고리별' 매출액

-- 그룹화 분석 기초 실습
-- 학생의 키 데이터를 성별에 따라 나누어 분석해보기
-- group_analysis DB 생성 및 진입
CREATE DATABASE group_analysis;
USE group_analysis;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	gender VARCHAR(10), 		-- 성별
	height DECIMAL(4, 1), 		-- 키
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (gender, height)
VALUES
	('male', 176.6),
	('female', 165.5),
	('female', 159.3),
	('male', 172.8),
	('female', 160.7),
	('female', 170.2),
	('male', 182.1);

-- 확인
SELECT * FROM students;

-- 전체 집계: 전체 학생의 평균 키 구하기
SELECT AVG(height)
FROM students;

-- 남학생의 평균
SELECT AVG(height)
FROM students
WHERE gender = 'male';

-- 여학생의 평균
SELECT AVG(height)
FROM students
WHERE gender = 'female';

-- 그룹화 분석: 각 성별 평균키 구하기
-- GROUP BY: 특정 컬럼의 값이 같은 행들을 하나의 그룹으로 묶어주는 역할
SELECT 그룹화_컬럼, 집계_함수(일반_컬럼) -- 각 그룹에 대한 통계를 낼 수 있음
FROM 테이블명
WHERE 조건
GROUP BY 그룹화_컬럼; -- 그룹화의 기준이 될 컬럼

SELECT gender, AVG(height)
FROM students 
GROUP BY gender; -- 성별을 기준으로 그룹화 하겠다

-- 그룹화의 특징 3가지
-- 1) 집계 함수와 함께 사용해야 함
-- 그룹별로 유의미한 분석을 얻기 위해서 집계 함수와 함께 사용
-- 단순 GROUP BY 절만 사용하는 것은 데이터를 그룹으로 묶기만 함(의미없음)
SELECT gender
FROM students 
GROUP BY gender;

-- 2) 여러 컬럼으로 그룹화 할 수 있다.
SELECT 그룹화_컬럼1, 그룹화_컬럼2, 집계_함수(일반_컬럼)
FROM 테이블명
WHERE 조건
GROUP BY 그룹화_컬럼1, 그룹화_컬럼2; -- 컬럼1로 그룹화하고, 그안에서 다시 컬럼2로 그룹화

-- 예: 특정 도시의 연도별 총매출 집계
-- sales 테이블 생성
CREATE TABLE sales (
	id INTEGER AUTO_INCREMENT,  	-- 아이디(자동으로 1씩 증가)
	city VARCHAR(50) NOT NULL,   	-- 도시명
	sale_date DATE NOT NULL,      	-- 판매 날짜
	amount INTEGER NOT NULL,     	-- 판매 금액
	PRIMARY KEY (id)				-- 기본키 지정: id
);

-- sales 데이터 삽입
INSERT INTO sales (city, sale_date, amount) 
VALUES
	('Seoul', '2023-01-15', 1000),
	('Seoul', '2023-05-10', 2000),
	('Seoul', '2023-08-29', 2500),
	('Seoul', '2024-02-14', 4000),
	('Busan', '2023-03-05', 1500),
	('Busan', '2024-05-10', 1800),
	('Busan', '2024-07-20', 3000),
	('Incheon', '2023-11-25', 1200),
	('Incheon', '2024-03-19', 2200),
	('Incheon', '2024-09-12', 3300);

-- 확인
SELECT * FROM sales;

-- 일단 먼저 특정 도시별 총매출 집계
SELECT city, SUM(amount)
FROM sales
GROUP BY city;

-- 특정 도시의 연도별 총매출 집계
SELECT 
city AS 도시, 
YEAR(sale_date) AS '판매 연도', 
SUM(amount) AS '총 매출' -- 3) 특정 도시의 연도별 총 매출 집계 조회
FROM sales -- 1) sales 테이블을 가져와서 
GROUP BY city, YEAR(sale_date); -- 2) 도시와 연도로 그룹화 한후

-- 3) SELECT 절에 올 수 있는 컬럼이 제한적이다.
-- 사용 가능한 컬럼:
-- -그룹화 컬럼: GROUP BY 절에서 지정한 컬럼( 그룹을 대표하는 값이라 가능) 
-- -집계된 컬럼: 집계 함수에 사용된 컬럼(그룹 전체를 요약한 값이라 가능)

-- 잘못된 컬럼 사용 예시
SELECT id, gender, AVG(height)
FROM students 
GROUP BY gender;

-- 이렇게는 가능
SELECT SUM(id), gender, AVG(height)
FROM students 
GROUP BY gender;

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하시오.
-- ① 그룹화 분석이란 데이터를 특정 그룹으로 나누어 분석하는 것이다. (  )
-- ② GROUP BY 절에는 반드시 하나의 칼럼만 지정해야 한다. (  )
-- ③ 그룹화된 쿼리에서 SELECT 절에 포함된 칼럼은 
-- GROUP BY 절에서 지정한 그룹화 칼럼이거나 집계 함수에 사용된 칼럼이어야 한다. (  )

-- 정답: o, x, o

/*
	8.2 그룹화 필터링, 정렬, 조회 개수 제한
*/
-- 실습 데이터 셋 만들기
-- payments 테이블 생성
CREATE TABLE payments (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	amount INTEGER, 			-- 결제 금액
	ptype VARCHAR(50), 			-- 결제 유형
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- payments 데이터 삽입
INSERT INTO payments (amount, ptype)
VALUES
	(33640, 'SAMSONG CARD'),
	(33110, 'SAMSONG CARD'),
	(31200, 'LOTTI CARD'),
	(69870, 'COCOA PAY'),
	(32800, 'COCOA PAY'),
	(42210, 'LOTTI CARD'),
	(46060, 'LOTTI CARD'),
	(42520, 'SAMSONG CARD'),
	(23070, 'COCOA PAY');

-- 확인
SELECT * FROM payments;

-- 1. 그룹화 필터링(HAVING)
-- 그룹화한 결과에서 특정 조건을 만족하는 그룹의 데이터만 가져오는 것
-- 주로 집계 함수 결과에 조건을 걸 때 사용
-- GROUP BY 절에 HAVING 절을 추가하여 수행

-- 형식
SELECT 그룹화_컬럼, 집계_함수(일반_컬럼)
FROM 테이블명
WHERE 일반_필터링_조건 -- 그룹화 하기 전에 개별 행(row)에 대해 필터링하는 행단위 필터링 (집계 함수 사용 불가)
GROUP BY 그룹화_컬럼
HAVING 그룹_필터링_조건; -- 그룹핑된 결과에 대해 필터링하는 그룹 단위 필터링 (집계 함수 사용 가능)

-- 결제 유형별 평균 결제 금액이 40,000원 이상인 데이터는?
-- 우선 결제 유형별(GROUP BY) 평균 결제 금액 구하기
SELECT 
AVG(amount) AS '평균 결제 금액', 
ptype AS '결제 유형'
FROM payments
-- WHERE AVG(amount) >= 40000 
-- 오류 발생: WHERE 절은 그룹화가 이루어지기전, 테이블의 개별생 하나하나에 대해 조건을 검사하기 때문
GROUP BY ptype
HAVING AVG(amount) >= 40000; -- 집계 함수는 HAVING 절에서 조건을 거는 게 맞음

-- (중요) SQL 작동 순서: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

-- (참고) MySQL 에서는 HAVING 절에서 SELECT 절의 별칭을 쓸 수 있다. (MySQL 허용)
-- 표준 SQL 문법에 따르면 HAVING 절은 SELECT 절보다 먼저 처리된다.
-- 따라서 SELECT 절에서 지정한 별칭 (alias)을 HAVING 절에서 사용하는 것은 원칙적으로 불가능
-- 따라서 집계 함수 표현식을 직접 사용하는 것이 안전하고 호환성이 높은 방법
SELECT 
AVG(amount) AS '평균 결제 금액', 
ptype AS '결제 유형'
FROM payments
-- WHERE AVG(amount) >= 40000 
-- 오류 발생: WHERE 절은 그룹화가 이루어지기전, 테이블의 개별생 하나하나에 대해 조건을 검사하기 때문
GROUP BY ptype
HAVING `평균 결제 금액` >= 40000; -- 주의! '' 로 묶으면 문자열로 인식

-- 정리: 
-- WHERE 는 그룹화 이전에 개개인을 걸러내는 조건
-- HAVING은 그룹화 이후에 그룹 자체를 걸러내는 조건

-- 2. 데이터 정렬 (ORDER BY)
-- 정렬: 쿼리 결과를 오름차순 또는 내림차순으로 배열하는 것
-- ORDER BY 절을 사용하여 수행
-- SELECT로 조회된 데이터를 기준으로 정렬하는 작업(SELECT가 먼저 수행됨)

-- (참고) SELECT와 WHERE만 사용해서 데이터를 조회하면, 그 결과는 어떤 순서롤 나올까?
-- 정답은 '알 수 없다' 또는 '데이터베이스 마음대로'

-- 형식
SELECT *
FROM 테이블명
WHERE 조건
ORDER BY 정렬_컬럼1[ASC | DESC], 정렬_컬럼2[ASC | DESC], ... ;

-- ASC: 오름차순(생략 시 기본 값)
-- DESC: 내림차순

-- 단일 컬럼 정렬: 결제(payments) 테이블에서 결제 금액이 높은 순서대로 조회하려면?
SELECT 
	ptype AS '결제 유형',
	amount AS '결제 금액' -- 2) 필요한 컬럼만 선택하고, 별칭을 부여한 후    
FROM payments  -- 1) payments 테이블에서 
ORDER BY amount DESC; -- 3) amount 기준으로 내림차순 정렬

-- 다중 컬럼 정렬: 결제(payments) 테이블에서 결제 유형은 오름차순, 결제 금액은 내림차순으로 정렬 하려면?
SELECT 
	ptype AS '결제 유형',
    amount AS '결제 금액'
FROM payments 
ORDER BY ptype, amount DESC; -- ptype 의 오름차순 정렬 후 그 안에서 amount의 내림차순 정렬(순서 중요)

-- 실무 Tip 
-- 오름차순인 경우 ASC 키워드는 생략 가능 (정렬의 기본값)
-- 실무에서는 오름차순인 경우에는 ASC 키워드를 대부분 생략하고 ORDER BY만 사용
-- 내림차순의 경우 DESC를 필수로 적어야 하기 때문에 생략하면 안됨

-- (참고) MySQL의 NULL 정렬 규칙
-- MySQL은 NULL을 가장 작은 값으로 취급함
-- ORDER BY column ASC(오름차순): NULL 값이 가장 먼저 나옴
-- ORDER BY column DESC(내림차순): NULL 값이 가장 나중에 나옴
-- 이것은 데이터베이스 시스템마다 정책이 다를 수 있음 (예: Oracle은 NULL을 가장 큰 값으로 취급)

-- 3. 조회 개수 제한 (LIMIT, OFFSET) 
-- 조회 결과 중 상위 N개의 레코드만을 조회하는 명령
-- LIMIT 절을 이용해 반환하려는 레코드의 개수를 정의 

-- 형식 
SELECT 컬럼1, 컬럼2, ...
FROM 테이블명
LIMIT n;

-- 결제 금액 상위 3개 데이터만 조회하려면?
SELECT 
	ptype AS '결제 유형',
    amount AS '결제 금액'
FROM payments 
ORDER BY amount DESC 
LIMIT 3;

-- 상위 N개 데이터가 아닌 중간 데이터를 가져오고 싶다면?
-- LIMTIT 절에 OFFSET 키워드를 추가해 읽어 올 데이터의 시작 지점을 조종할 수 있음

-- 형식
SELECT 컬럼1, 컬럼2, ...
FROM 테이블명
LIMIT N OFFSET M; -- N: 가져올 레코드의 개수, M: 걸너뛸 레코드의 개수
-- LIMIT M, N; 

-- 결제 금액 4등~ 6등까지 조회
SELECT 
	ptype AS '결제 유형',
    amount AS '결제 금액' -- 2) 출력할 컬럼을 선택하고
FROM payments -- 1) payments 테이블에서 
ORDER BY amount DESC  -- 3) amount 의 내림차순으로 정렬한 후
LIMIT 3 OFFSET 3; -- 4) 상위 3개의 행은 건너뛰고 3개 행만 가져옴

-- Tip: LIMIT 활용 
-- 페이지네이션(Pagination) 구현할 때 SQL에서 가장 기본적으로 사용
-- 예: 한 페이지당 10개씩 보여줄 경우
-- 1페이지 
SELECT * 
FROM products 
LIMIT 0,10; 

-- 2페이지
SELECT * 
FROM products 
LIMIT 10,10;

-- 3페이지
SELECT * 
FROM products 
LIMIT 20,10;

-- (하드코딩x)OFFSET 계산 방법 (공식화)
-- OFFSET = (현제 페이지 번호 - 1) * 페이지당 개수 
-- 1페이지: OFFSET = (1 - 1) * 10 = 0 
-- 2페이지: OFFSET = (2 - 1) * 10 = 10
-- 3페이지: OFFSET = (3 - 1) * 10 = 20

-- 정렬은 반드시 함께 쓰자 !
-- 정렬 없이 LIMIT만 쓰면 페이지가 뒤죽박죽 될 수 있음
SELECT *
FROM products 
ORDER BY created_at DESC
LIMIT 10 OFFSET 20;

-- (참고) 성능 주의사항
-- OFFSET이 커질수록 성능이 떨어짐(건너뛸 데이터를 계속 읽기 때문)
-- 대규모 데이터에서는 커서 기반 페이지네이션이나 키셋 페이지네이션을 고려하기도 함

-- Quiz
-- 다음은 payments 테이블에서 ptype(결제 유형)별로 결제 횟수와 평균 결제 금액을 구하는 쿼리이다.
-- 빈칸을 순서대로 채워 이를 완성하시오.

-- 그룹화와 정렬
-- -------------------------------------
-- 결제 유형      | 결제 횟수  | 평균 결제 금액
-- -------------------------------------
-- COCOA PAY    | 3        | 41913.3333
-- LOTTI CARD   | 3        | 39823.3333
-- SAMSONG CARD | 3        | 36423.3333

SELECT 
	ptype AS '결제 유형',
	① __________ AS '결제 횟수',
	AVG(amount) AS '평균 결제 금액'
FROM payments
GROUP BY ② __________
ORDER BY COUNT(*) DESC, ③ __________ DESC;

-- 정답:
SELECT 
	ptype AS '결제 유형',
	COUNT(*) AS '결제 횟수',
	AVG(amount) AS '평균 결제 금액'
FROM payments
GROUP BY ptype
ORDER BY COUNT(*) DESC, AVG(amount) DESC;


/*
	8.3 그룹화 분석 실습: 마켓 DB
*/
-- 마켓 DB를 활용하여 그룹화, 그룹화 필터링, 정렬, 조회 개수 제한을 연습!
-- (ch08_09_market_db.png 참고)

-- 마켓 DB 데이터 셋
-- • users(사용자): 사용자의 id(아이디), email(이메일), nickname(닉네임)을 저장합니다.
-- • orders(주문): 주문의 id(아이디), status(주문 상태), created_at(주문 생성 시각)을 저장합니다.
-- • payments(결제): 결제의 id(아이디), amount(결제 금액), payment_type(결제 유형)을 저장합니다.
-- • products(상품): 상품의 id(아이디), name(상품명), price(가격), product_type(상품 유형)을 저장합니다.
-- • order_details(주문 상세): 주문 상세의 id(아이디), count(판매 수량)를 저장합니다.

-- 제약 조건
-- 모든 id 컬럼은 AUTO_INCREMENT
-- users 테이블의 email, nickname은 고유한 값만 허용

-- market DB 생성 및 진입
CREATE DATABASE market;
USE market;

-- users 테이블 생성
CREATE TABLE users(
	id INTEGER AUTO_INCREMENT, 	
	email VARCHAR(100) UNIQUE,
	nickname VARCHAR(100) UNIQUE,
	PRIMARY KEY (id) 	
);


-- orders 테이블 생성
CREATE TABLE orders(
	id INTEGER AUTO_INCREMENT,
	status VARCHAR(50),
	created_at DATETIME,
	user_id INTEGER,
	PRIMARY KEY (id),
	FOREIGN KEY(user_id) REFERENCES users(id)
);


-- payments 테이블 생성
CREATE TABLE payments(
	id INTEGER AUTO_INCREMENT,
	amount INTEGER,
	payment_type VARCHAR(50),
	order_id INTEGER UNIQUE, -- 1:1 강제하는 효과
	PRIMARY KEY (id),
	FOREIGN KEY(order_id) REFERENCES orders(id)
);


-- products 테이블 생성
CREATE TABLE products(
id INTEGER AUTO_INCREMENT,
name VARCHAR(100),
price INTEGER,
product_type VARCHAR(100),
PRIMARY KEY (id)
);


-- order_details 테이블 생성
CREATE TABLE order_details(
id INTEGER AUTO_INCREMENT,
order_id INTEGER,
product_id INTEGER,
count INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 확인
-- SHOW DATABASES;
SELECT DATABASE();
SHOW TABLES;


-- users 데이터 삽입
INSERT INTO users (email, nickname)
VALUES
	('sehongpark@cloudstudying.kr', '홍팍'),
	('kuma@cloudstudying.kr', '쿠마'),
	('hawk@cloudstudying.kr', '호크');
    
-- orders 데이터 삽입
INSERT INTO orders (status, created_at, user_id)
VALUES
	('배송 완료', '2024-11-12 11:07:12', 1),
	('배송 완료', '2024-11-17 22:14:54', 1),
	('배송 완료', '2024-11-24 19:13:46', 2),
	('배송 완료', '2024-11-29 23:57:29', 3),
	('배송 완료', '2024-12-06 22:25:13', 3),
	('배송 완료', '2025-01-02 13:04:25', 2),
	('배송 완료', '2025-01-06 15:45:51', 2),
	('장바구니', '2025-03-06 14:54:23', 1);
    
-- payments 데이터 삽입
INSERT INTO payments (amount, payment_type, order_id)
VALUES
	(9740, 'SAMSONG CARD', 1),
	(13800, 'SAMSONG CARD', 2),
	(32200, 'LOTTI CARD', 3),
	(28420, 'COCOA PAY', 4),
	(18000, 'COCOA PAY', 5),
	(5910, 'LOTTI CARD', 6),
	(17300, 'LOTTI CARD', 7);
    
-- products 데이터 삽입
INSERT INTO products (name, price, product_type)
VALUES
	('우유 900ml', 1970, '냉장 식품'),
	('참치 마요 120g', 4400, '냉장 식품'),
	('달걀 감자 샐러드 500g', 6900, '냉장 식품'),
	('달걀 듬뿍 샐러드 500g', 6900, '냉장 식품'),
	('크림 치즈', 2180, '냉장 식품'),
	('우유 식빵', 2900, '상온 식품'),
	('샐러드 키트 6봉', 8900, '냉장 식품'),
	('무항생제 특란 20구', 7200, '냉장 식품'),
	('수제 크림 치즈 200g', 9000, '냉장 식품'),
	('플레인 베이글', 1300, '냉장 식품');
    
-- order_details 데이터 삽입
INSERT INTO order_details (order_id, product_id, count)
VALUES
	(1, 1, 2),
	(1, 6, 2),
	(2, 3, 1),
	(2, 4, 1),
	(3, 7, 2),
	(3, 8, 2),
	(4, 2, 3),
	(4, 5, 4),
	(4, 10, 5),
	(5, 9, 2),
	(6, 1, 3),
	(7, 8, 2),
	(7, 6, 1),
	(8, 6, 3);

-- 확인
-- SHOW DATABASES;
SELECT DATABASE();
SHOW TABLES;

-- 상품 유형별 집계하기
-- 상품(products) 테이블에서 상품 유형별 상품의 개수, 최고 가격, 최저 가격을 구하려면?
SELECT 
	product_type AS '상품의 유형',
    COUNT(*) AS '상품 개수',
    MAX(price) AS '최고 가격',
	MIN(price) AS '최저 가격'
FROM products
GROUP BY product_type;

-- 사용자 주문 총액 필터링 하기 
-- 사용자별 주문 총액을 구하고, 그 총액이 30,000 원 이상인 주문자의 주문자명 
SELECT 
	nickname AS '이름',
  SUM(amount) AS '주문금액'
FROM users u -- 1) 사용자 테이블에 
JOIN orders o ON u.id = o.user_id -- 2) 주문 테이블 을 붙이고  
JOIN payments p ON o.id = p.order_id-- 3) 결제 테이블을 붙여서
GROUP BY u.id  -- 
HAVING SUM(amount) >= 30000; -- 5) 그룹 필터링을 하고

-- 가장 많이 팔린 상품 TOP3
-- 상품별 판매 수량을 집계 했을 때, 가장 많이 팔린 상품 TOP3의 상품 명과 판매수량은?

SELECT *
FROM products p
JOIN order_details od ON p.id = od.product_id
-- 1) orders 테이블에 장바구니 정보도 함께 저장되어서 이를 구분하기 위해 JOIN을 한번 더하고
JOIN orders o ON od.order_id = o.id
WHERE status = '배송 완료'; -- 2) 배송 완료 레코드만 필터링

-- 그룹화, 집계
SELECT 
	name AS '상품명',
    SUM(count) AS '판매 수량'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
WHERE status = '배송 완료'
GROUP BY p.id, name;
-- HAVING status = '배송 완료'; -- 에러 발생
-- HAVING 조건에 사용 가능한 컬럼: GROUP BY 절에 포함된 컬럼, 집계 함수로 집계된 컬럼

-- 정렬 + 개수 제한
SELECT 
	p.name AS '상품명',
    SUM(count) AS '판매 수량' -- 6)
FROM products p -- 1)
JOIN order_details od ON p.id = od.product_id -- 2)
JOIN orders o ON od.order_id = o.id -- 3)
WHERE status = '배송 완료' -- 4)
GROUP BY p.id, p.name -- 5)
ORDER BY SUM(count) DESC, p.name -- 7)
LIMIT 3; -- 8) 경계에서 잘릴 경우 DB 엔진 내부 구현에 따라 가져옴

-- Quiz
-- 3. market DB에서 배송 완료된 상품별로 누적 매출 상위 3개 상품 정보를 조회하고자 한다.
-- 다음 쿼리의 빈칸을 채워 완성하시오.

-- ------------------------------
-- 상품명              | 누적 매출
-- ------------------------------
-- 무항생제 특란 20구    | 28800
-- 수제 크림 치즈 200g  | 18000
-- 샐러드 키트 6봉      | 17800

SELECT 
	name AS '상품명',
	SUM(① __________) AS '누적 매출'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
			AND status = '배송 완료'
GROUP BY name
ORDER BY SUM(② __________) DESC
LIMIT 3;

-- 정답: 
SELECT 
	name AS '상품명',
	SUM(price*count) AS '누적 매출'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
			AND status = '배송 완료'
GROUP BY name
ORDER BY SUM(price*count) DESC
LIMIT 3;

















