-- 셀프체크
-- 8장에서 만든 market DB의 상품 중 가격이 낮은 하위 4개의 누적 매출을 다음과 같이 조회하고 싶습니다.
-- 이를 위한 쿼리를 작성하세요.
-- (ch08_09_market_db.png 참고)

-- ----------------------------------
-- 상품명        | 가격     | 누적 매출
-- ----------------------------------
-- 플레인 베이글  | 1300    | 6500
-- 우유 900ml    | 1970    | 9850
-- 크림 치즈      | 2180    | 8720
-- 우유 식빵      | 2900    | 8700

-- 누적 매출은 price * count(가격 * 판매 수량)으로 구합니다.

USE market;

SELECT 
	name AS '상품명',
    p.price AS '가격',
	SUM(price*count) AS '누적 매출'
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
			AND status = '배송 완료'
GROUP BY name ,p.price
ORDER BY p.price, name
LIMIT 4;


