-- 회원과 비회원 구분
SELECT session
    , user_id
    , stamp
    
    -- 로그를 stamp 순서로 나열하고 한번이라도 로그인한 사용자일 경우 이후 모든 로그 상태를 member로 설정
    , CASE WHEN COALESCE(MAX(user_id) OVER(PARTITION BY session ORDER BY stamp), '') <> '' THEN 'Member'
	   ELSE 'None' END AS member_status
FROM action_log;



-- CONCAT 내부 CASE WHEN 구문
SELECT sex
    , age
    , CONCAT(IF(age >= 20, sex, '')
	      , CASE WHEN age >= 45 THEN 'Adult'
   	             WHEN age >= 4 THEN 'Child' END
	    ) AS category
FROM mst_users_with_age;



-- CASE 구문
SELECT CASE has_purchase WHEN 1 THEN 'purchase'
			 WHEN 0 THEN 'not purchase'
			 ELSE 'any' END AS has_purchase
FROM action_venn_diagram;



-- NTILE : 같은 수로 데이터 그룹 생성
SELECT user_id
    , SUM(amount) AS purchase_amount
    , NTILE(10) OVER(ORDER BY SUM(amount) DESC) AS decile
FROM action_log
GROUP BY user_id;
