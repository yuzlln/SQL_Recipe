-- 문자열 분해
SELECT url
    , SUBSTRING_INDEX(SUBSTRING_INDEX(url, 'm/', -1), '/', 1) AS path1
FROM access_log;



-- 현재 날짜와 타임스템프
SELECT CURRENT_DATE() AS dt
    , CURRENT_TIMESTAMP() AS stamp;
    


-- 데이터 타입 변환
SELECT CAST('2024-07-27' AS date) AS dt
    , CAST('2024-07-27 12:34:56' AS datetime) AS stamp;
    
    
    
--  특정 필드 추출

-- 방법 1) EXTRACT 함수
SELECT stamp
    , EXTRACT(YEAR FROM stamp) AS year -- YEAR/MONTH/DAY/HOUR/MINUTE/SECOND
FROM (SELECT CAST('2024-07-27 12:34:56' AS datetime) AS stamp
	  ) AS t; -- FROM절 서브쿼리 별칭 필수
            
            
-- 방법 2) SUBSTRING 함수
SELECT stamp
    , SUBSTRING(stamp, 6, 2) AS month
    , SUBSTRING(stamp, -8) AS time
FROM (SELECT CAST('2024-07-27 12:34:56' AS char) AS stamp
      ) AS t;
      
      
      
-- 결측치 대체
SELECT COALESCE(coupon, 0) AS coupon1 -- 0으로 대치
FROM purchase_log_with_coupon;