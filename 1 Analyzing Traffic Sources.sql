USE  mavenfuzzyfactory;

-- TRAFFIC CONVERSION RATES --

-- SELECT 
-- 	website_sessions.utm_content, 
-- 	COUNT(DISTINCT website_sessions.website_session_id) AS Sessions, 
--     COUNT(DISTINCT orders.order_id) AS Orders,
--     COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS order_per_sessions
-- FROM website_sessions 
-- 	LEFT JOIN orders
-- 		ON orders.website_session_id = website_sessions.website_session_id
-- WHERE website_sessions.website_session_id between 1000 AND 2000 

-- GROUP BY 1
-- ORDER BY 2 DESC;

-- ASSIGNMENT 1

-- SELECT 
-- 	utm_source AS UTMSource, 
--     utm_campaign AS campaign, 
--     http_referer AS referring_domain,
--     COUNT(DISTINCT website_session_id) AS Sessions
-- FROM website_sessions
-- WHERE created_at < '2012-04-12'

-- GROUP BY 
-- utm_source,
-- utm_campaign,
-- http_referer

-- ORDER BY Sessions DESC;


-- ASSIGNMENT 2

-- SELECT 
--     COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
--     COUNT(DISTINCT orders.order_id) AS Orders,
--     COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS CVR
-- FROM website_sessions
-- 	LEFT JOIN orders
--      ON orders.website_session_id = website_sessions.website_session_id
-- WHERE website_sessions.created_at < '2012-04-14'
-- 	  AND utm_source = 'gsearch'
--       AND utm_campaign = 'nonbrand'
-- ;


-- BID OPTIMIZATION --

-- SELECT 
--     WEEK(created_at) AS created_wk,
--     YEAR(created_at) AS created_yr,
--     MIN(DATE(created_at)) AS week_start,
--     COUNT(DISTINCT website_session_id) AS sessions
-- FROM website_sessions
-- WHERE website_session_id between 100000 AND 115000
-- GROUP BY 
-- created_wk, 
-- created_yr
-- ;


-- SELECT  
--     primary_product_id,
--     COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS orders_with_1_item,
--     COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS orders_with_2_item,
--     COUNT(DISTINCT order_id) AS total_orders
-- FROM orders
-- WHERE order_id between 31000 AND 32000
-- group by
-- 	primary_product_id
-- ;


-- ASSIGNMENT 3

-- SELECT 
--         MIN(date(created_at)) AS start_date,
--         COUNT(DISTINCT website_session_id) AS sessions
-- FROM website_sessions
-- WHERE created_at < '2012-05-10' 
-- 	AND utm_source = 'gsearch'
-- 	AND utm_campaign = 'nonbrand'
-- GROUP BY 
-- 	WEEK(created_at)
-- ;


-- ASSIGNMENT 4

-- SELECT 
-- 	website_sessions.device_type AS Device,
--     COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
--     COUNT(DISTINCT orders.order_id) AS orders,
--     COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
-- FROM website_sessions
-- 	LEFT JOIN orders
-- 		ON orders.website_session_id = website_sessions.website_session_id

-- WHERE website_sessions.created_at < '2012-05-11' 
-- 	AND website_sessions.utm_source = 'gsearch'
-- 	AND website_sessions.utm_campaign = 'nonbrand'
--     
-- GROUP BY
-- 	1
-- ;


-- ASSIGNMENT 5

-- SELECT 
-- 	MIN(DATE(created_at)) AS week_start_date,
--     COUNT(DISTINCT CASE WHEN device_type ='desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions, 
--     COUNT(DISTINCT CASE WHEN device_type ='mobile' THEN website_session_id ELSE NULL END) AS mob_sessions
-- FROM website_sessions
-- WHERE created_at < '2012-06-09'
-- 	AND created_at > '2012-04-15'
-- 	AND utm_source = 'gsearch'
-- 	AND utm_campaign = 'nonbrand'
-- GROUP BY 
-- 	week(created_at)
-- ;

