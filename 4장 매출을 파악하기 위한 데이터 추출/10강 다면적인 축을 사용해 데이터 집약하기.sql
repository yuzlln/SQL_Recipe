-- ROLLUP : 그룹별 소계와 전체 합계를 같이 나타낼 때 사용
-- 카테고리별 합계 + 전체 합계
-- 전체 합계를 나타내는 레코드 집계 키가 NULL이므로 변환 필요
SELECT COALESCE(category, 'ALL') AS category
   , COALESCE(sub_category, 'ALL') AS sub_category
   , SUM(price) AS amount
FROM purchase_detail_log
GROUP BY category
	 , sub_category WITH ROLLUP
ORDER BY category
	 , sub_category;