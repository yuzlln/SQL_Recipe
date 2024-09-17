-- 원래 값 + 집약 함수 (윈도 함수)
SELECT product_id
	, score
	, AVG(score) OVER() AS avg_score -- score 전체 평균
    , AVG(score) OVER(PARTITION BY user_id) AS user_avg_score -- user_id별 core 평균
FROM review;



-- 순서 정의
SELECT product_id
  	, score
    , ROW_NUMBER() OVER(ORDER BY score DESC) AS `row`        -- 유일한 순위
    , RANK() OVER(ORDER BY score DESC) AS `rank`             -- 같은 순위 레코드 뒤의 순위 번호 건너 뜀
    , DENSE_RANK() OVER(ORDER BY score DESC) as `dense_rank` -- 순위 번호 건너뛰지 않음
FROM popular_products;



-- 앞/뒤행 추출
SELECT product_id
    -- 1) LAG : 현재 행을 기준으로 앞의 행의 값 추출
    , LAG(product_id) OVER(ORDER BY score DESC) AS lag1
    , LAG(product_id, 2) OVER(ORDER BY score DESC) AS lag2
  
    -- 2) LEAD : 현재 행을 기준으로 뒤의 행의 값 추출
    , LEAD(product_id) OVER(ORDER BY score DESC) AS lead1
    , LEAD(product_id, 2) OVER(ORDER BY score DESC) AS lead2
FROM popular_products;


/*
Window Function → ‘ROWS BETWEEN start AND END’

CURRENT ROW (현재 행), n PRECEDING (n행 앞), n FOLLOWING (n행 뒤),
UNBOUNDED PRECEDING (이전 행 전부), UNBOUNDED FOLLOWING (이후 행 전부)

윈도 함수에 프레임을 지정하지 않으면
ORDER BY 구문이 없는 경우 : 모든 행
ORDER BY 구문이 있는 경우 : 첫 행에서 현재 행까지 
*/


-- ORDER BY + 집약 함수
SELECT score
    -- 1) 순위 상위부터 누계 점수
    , SUM(score) OVER(ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_score1
    -- , SUM(score) OVER(ORDER BY score DESC) AS cum_score2와 동일한 결과값
  
    -- 2) 현재 행 + 앞/뒤 1행 평균
    , AVG(score) OVER(ORDER BY score DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS loca_avg
FROM popular_products;



-- 첫번째/마지막 레코드
SELECT product_id

    -- 1) 윈도 내부의 가장 첫번째 레코드
    , FIRST_VALUE(product_id) OVER(ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS `first_value`
 
    -- 2) 윈도 내부의 가장 마지막 레코드
    , LAST_VALUE(product_id) OVER(ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS `last_value`
FROM popular_products;



-- 카테고리별 TOP1 제품
SELECT DISTINCT category
	, FIRST_VALUE(product_id) OVER(PARTITION BY category ORDER BY score DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS product_id
FROM popular_products;



-- 행을 집약해서 구분자로 구분된 문자열로 변환
SELECT purchase_id
	, GROUP_CONCAT(product_id SEPARATOR ', ') AS product_ids
FROM purchase_detail_log
GROUP BY purchase_id;



-- 순번 테이블 만들기
SELECT 1 AS idx
UNION ALL SELECT 2 AS idx
UNION ALL SELECT 3 AS idx;



-- CROSS JOIN

-- 한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인
-- 전체 행 개수 = 두 테이블의 행 개수를 곱한 값
SELECT *
FROM city AS c
CROSS JOIN transport AS t;

SELECT *
FROM city AS c 
JOIN transport AS t; -- ON 조건이 없으므로 CROSS JOIN

SELECT *
FROM city AS c, transport AS t;