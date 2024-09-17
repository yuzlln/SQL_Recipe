-- 문자열 연결
SELECT CONCAT(pref_name, ' ', city_name) AS pref_city
FROM mst_user_location;



-- SIGN 함수
SELECT SIGN(q2 - q1) AS sign_q2_q1 -- 매개변수에 따라 1, 0, -1, NULL 출력
FROM quarterly_sales;



-- 최댓값/최솟값
SELECT GREATEST(q2, q3, q4) AS greatest_sales
	, LEAST(q2, q3, q4) AS least_sales
FROM quarterly_sales;



-- NULL 전파 : NULL을 포함한 데이터의 연산 결과는 모두 NULL
SELECT dt
    , 100 * (clicks / NULLIF(impressions, 0)) AS ctr_by_null -- NULLIF(exp1, exp2) : exp1이 exp2이면 NULL, 그렇지 않으면 exp1
FROM advertising_stats;



-- 날짜/시간 데이터 계산
SELECT register_stamp
    , DATE_ADD(register_stamp, INTERVAL 1 DAY) AS after_1_day -- YEAR/MONTH/DAY
    , DATE_ADD(register_stamp, INTERVAL -30 MINUTE) AS before_30_min -- HOUR/MINUTE/SECOND
FROM mst_users_with_dates;



-- 날짜 데이터 차이 (day 단위)
SELECT user_id
    , DATEDIFF(CURRENT_DATE(), DATE(register_stamp)) AS diff_days -- DATEDIFF(날짜1, 날짜2) : 날짜1 > 날짜2
FROM mst_users_with_dates;



-- 날짜 데이터 차이 (지정 단위)
SELECT user_id
    -- TIMESTAMPDIFF(unit, 날짜1, 날짜2) : 날짜1 < 날짜2, unit = YEAR/MONTH/DAY
    , TIMESTAMPDIFF(YEAR, birth_date, DATE(register_stamp)) AS register_age 
FROM mst_users_with_dates;



-- 정수 표현 나이 계산
SELECT FLOOR((20240727 - 19970918) / 10000) AS age; -- 날짜를 고정 자리 수의 정수로 표현



-- 문자열 대체
SELECT REPLACE(birth_date, '-', '') AS date1
FROM mst_users_with_dates;



-- 정수형 변환
SELECT CAST(REPLACE(birth_date, '-', '') AS unsigned) AS date1
FROM mst_users_with_dates;