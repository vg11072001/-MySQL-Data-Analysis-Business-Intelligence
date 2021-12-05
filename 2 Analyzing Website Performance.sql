USE  mavenfuzzyfactory;

-- Analyzing Top Website Pages & Entry Pages-- 

-- (1)

-- CREATE TEMPORARY TABLE 
-- SELECT *
-- FROM website_pageviews
-- WHERE  website_pageview_id <1000  -- arbitary


-- CREATE TEMPORARY TABLE 
-- SELECT 
-- 	pageview_url,
--     count(distinct website_session_id) as page_views
-- FROM website_pageviews
-- WHERE  website_pageview_id <1000  -- arbitary
-- GROUP BY pageview_url 
-- ORDER BY page_views DESC

-- (2) - one part of multi query theory

-- CREATE TEMPORARY TABLE first_pageview
-- SELECT 
-- 	 website_session_id,
--      MIN(website_pageview_id) AS min_pv_id
-- FROM website_pageviews
-- WHERE website_pageview_id <1000 
-- GROUP BY website_session_id;

-- SELECT * 
-- FROM first_pageview
-- 	LEFT JOIN website_pageviews
-- 		ON first_pageview.min_pv_id = website_pageviews.website_pageview_id;

-- SELECT 
-- 	website_pageviews.pageview_url As landing_page,
--     COUNT(Distinct first_pageview.website_session_id) AS sessions_hitting_this_lander
-- FROM first_pageview
-- 	LEFT JOIN website_pageviews
-- 		ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
-- 	GROUP BY website_pageviews.pageview_url; 

-- ASSIGNMENT 1

-- SELECT 
-- 	pageview_url,
--     COUNT(DISTINCT website_session_id )	AS sessions
-- FROM website_pageviews 
-- WHERE created_at < "2012-06-09"
-- GROUP BY pageview_url
-- ORDER BY sessions DESC;

-- ASSIGNMENT 2


CREATE TEMPORARY TABLE firstpageviews
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM 
	website_pageviews
WHERE 
	created_at < "2012-06-12"
GROUP BY
	website_session_id;

-- SET GLOBAL max_allowed_packet = 1073741824;

SELECT 
	website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT firstpageviews.website_session_id)
FROM website_pageviews
	LEFT JOIN firstpageviews
		ON website_pageviews.website_pageview_id = firstpageviews.min_pv_id
GROUP BY 
	website_pageviews.pageview_url;
	
	
