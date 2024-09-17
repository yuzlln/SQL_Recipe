-- 테이블 세로 결합
SELECT name
    , email
    , NULL AS phone -- 한쪽 테이블에만 존재하는 컬럼은 SELECT문에서 NULL로 처리
FROM app1_mst_users 

UNION ALL -- UNION 구문을 사용하면 중복을 제외한 결과

SELECT name
    , NULL AS email
    , phone
FROM app2_mst_users;



-- JOIN 추가 조건
SELECT *
FROM mst_categories AS m
	LEFT JOIN product_sale_ranking AS p ON m.category_id = p.category_id
		AND p.rankk = 1;
                
                
                
 -- SELECT 구문 내 상관 서브 쿼리
 
 -- JOIN을 사용하지 않아 마스터 테이블의 행 수가 변하지 않음
-- 외부 쿼리의 칼럼 값에 의존하므로 GROUP BY를 사용하지 않아도 마스터 테이블에 있는 category_id별로 ORDER BY 적용 
SELECT m.*
    , (SELECT product_id
	   FROM product_sale_ranking AS p
       WHERE m.category_id = p.category_id
	   ORDER BY sales DESC
       LIMIT 1
      ) AS top_sale_product -- 상관 서브 쿼리 
FROM mst_categories AS m;



-- CTE(Common Table Expression) : 일시적인 테이블에 이름을 붙여 재사용
-- WITH 구문 사용해서 여러개 테이블 정의 할때는 쉼표를 사용해 테이블 나열
-- 앞에서 사용한 CTE 구문을 다음 CTE 구문에서 바로 사용 가능
WITH product_sales_ranking AS (
	SELECT *
		, ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS num
	FROM product_sales
)
, mst_rank AS ( 	
	SELECT DISTINCT num
	FROM product_sales_ranking
)

SELECT *
FROM mst_rank;