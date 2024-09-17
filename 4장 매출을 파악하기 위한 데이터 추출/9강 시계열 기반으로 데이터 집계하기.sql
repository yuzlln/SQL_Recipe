-- 이동평균을 사용한 날짜별 추이
SELECT dt
    , SUM(purchase_amount) AS total_amount
    
    -- 1) 최근 최대 7일 동안의 평균
    , AVG(SUM(purchase_amount)) OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS seven_day_avg
  
    -- 2) Strict 한 최근 7일 동안의 평균
    , CASE WHEN COUNT(*) OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) = 7
        THEN AVG(SUM(purchase_amount)) OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
        END AS strict_seven_day_avg
FROM purchase_log
GROUP BY dt
ORDER BY dt;



-- 일별/월별/전체 누계 매출
SELECT dt
    -- 1) 일별 누계 매출
    , SUM(purchase_amount) AS daily_amount
    , DATE_FORMAT(dt, '%Y-%m') AS 'year_month'
  
    -- 2) 월별 누계 매출
    , SUM(SUM(purchase_amount)) OVER(PARTITION BY DATE_FORMAT(dt, '%Y-%m') ORDER BY dt ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS month_amount
	
    -- 3) 전체 누계 매출
    , SUM(SUM(purchase_amount)) OVER(ORDER BY dt ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_amount
FROM purchase_log
GROUP BY dt;



-- 12개월 전 매출 (ex. 2015-05 경우 2014-05 매출액)
SELECT CONCAT(year, '-', month) AS 'year_month'
    , LAG(sum_amount, 12) OVER(ORDER BY year, month) AS last_year_sum_amount
FROM monthly_purchase
ORDER BY 'year_month';
