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

-- CREATE TEMPORARY TABLE firstpageviews
-- SELECT 
-- 	website_session_id,
--     MIN(website_pageview_id) AS min_pv_id
-- FROM 
-- 	website_pageviews
-- WHERE 
-- 	created_at < "2012-06-12"
-- GROUP BY
-- 	website_session_id;

-- SELECT 
-- 	website_pageviews.pageview_url AS landing_page,
--     COUNT(DISTINCT firstpageviews.website_session_id)
-- FROM website_pageviews
-- 	LEFT JOIN firstpageviews
-- 		ON website_pageviews.website_pageview_id = firstpageviews.min_pv_id
-- GROUP BY 
-- 	website_pageviews.pageview_url;
	

-- BUSINESS CONETEXT : we want to see landing page performance for a certain period of time

-- STEP1: Find the first website_pageview_id for relevant sessions
-- STEP2: Identify the landing page of each session
-- STEP3: Counting pageviews for each session to identify "bounces"
-- STEP4: Summarizing total sessions and bounced sessions by LP

-- finding minimum website pageview id associated with each session we care about
-- 1.(
SELECT
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
    ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 
	website_pageviews.website_session_id;
   
-- same query as above, but we are storing the dataset as a temporary as a template table

CREATE TEMPORARY TABLE first_pageviews_demo1
SELECT
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
    ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 
	website_pageviews.website_session_id;
    
SELECT * FROM first_pageviews_demo1;
-- )

-- 2(
-- next we'll bring in the landing page to each session

CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT 
	first_pageviews_demo1.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo1
	LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = first_pageviews_demo1.min_pv_id; -- website pageview is the landing page view;
SELECT * From  sessions_w_landing_page_demo;
-- )

-- 3(
-- next we make a table to include a count of pageviews per session
-- first, we'll see all of the sesssions. Then we will limit to bounced sessions and create a temp table

CREATE TEMPORARY TABLE bounced_sessions_only ;
SELECT 
	sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_page_viewed
FROM sessions_w_landing_page_demo
LEFT JOIN website_pageviews
 ON website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id

GROUP BY 
	sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;
 
-- )
-- 4(

SELECT 
	sessions_w_landing_page_demo.landing_page,
    sessions_w_landing_page_demo.website_session_id,
    bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM sessions_w_landing_page_demo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
ORDER BY 
	sessions_w_landing_page_demo.website_session_id;
-- )

-- 5(
    
-- final output 
 -- we will use the same query we prviously ran, and run a count of records
 -- we will group by landing page, and then we'll add abounce rate coloumn
 
SELECT 
	sessions_w_landing_page_demo.landing_page,
    count( distinct sessions_w_landing_page_demo.website_session_id) AS session,
    count( distinct bounced_sessions_only.website_session_id) AS bounced_website_session_id,
    count( distinct bounced_sessions_only.website_session_id)/count( distinct sessions_w_landing_page_demo.website_session_id) AS bounce_rate
FROM sessions_w_landing_page_demo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_w_landing_page_demo.landing_page;

-- )

-- Assignment 3 CALCULATING BOUNCING RATES

-- 1
CREATE TEMPORARY TABLE pageviews_first_demo
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	WHERE created_at < '2012-06-14'  
GROUP BY 
	website_pageviews.website_session_id;
    
SELECT * FROM pageviews_first_demo;

-- 2
CREATE TEMPORARY TABLE session_w_landing_pages1
SELECT 
	pageviews_first_demo.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM pageviews_first_demo
LEFT JOIN website_pageviews	
	ON pageviews_first_demo.min_pv_id = website_pageviews.website_pageview_id;

SELECT * FROM session_w_landing_pages1;

-- 3
CREATE TEMPORARY TABLE bounced__session2
SELECT 
	session_w_landing_pages1.website_session_id,
    session_w_landing_pages1.landing_page ,
    COUNT(website_pageviews.website_session_id) AS counts_pagesview2
FROM session_w_landing_pages1
LEFT JOIN website_pageviews	
	ON session_w_landing_pages1.website_session_id = website_pageviews.website_session_id
GROUP BY 
	session_w_landing_pages1.website_session_id,
    session_w_landing_pages1.landing_page
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;

SELECT * FROM bounced__session2;

-- 4
SELECT 
	session_w_landing_pages1.landing_page,
    session_w_landing_pages1.website_session_id,
    bounced__session2.website_session_id AS bounced_website_session_id
FROM session_w_landing_pages1
	LEFT JOIN bounced__session2
    ON bounced__session2.website_session_id = session_w_landing_pages1.website_session_id
ORDER BY
	session_w_landing_pages1.website_session_id;
    
-- 5
SELECT 
	session_w_landing_pages1.landing_page,
    COUNT( DISTINCT session_w_landing_pages1.website_session_id) AS sessions,
    COUNT( DISTINCT bounced__session2.website_session_id) AS bounced_website_session_id,
    COUNT( DISTINCT bounced__session2.website_session_id)/COUNT( DISTINCT session_w_landing_pages1.website_session_id) AS bounced_rates
FROM session_w_landing_pages1
	LEFT JOIN bounced__session2
    ON bounced__session2.website_session_id = session_w_landing_pages1.website_session_id
GROUP BY
	session_w_landing_pages1.landing_page
;

-- Assignment 4 

SELECT *
FROM website_pageviews
WHERE created_at < '2012-06-28' AND pageview_url = '/lander-1';

-- 1
CREATE TEMPORARY TABLE pageviews_first_demo4
SELECT 
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	WHERE created_at < '2012-06-14'  
GROUP BY 
	website_pageviews.website_session_id;
    
SELECT * FROM pageviews_first_demo4;

-- 2
CREATE TEMPORARY TABLE session_w_landing_pages4
SELECT 
	pageviews_first_demo4.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM pageviews_first_demo4
LEFT JOIN website_pageviews	
	ON pageviews_first_demo4.min_pv_id = website_pageviews.website_pageview_id;

SELECT * FROM session_w_landing_pages1;

-- 3
CREATE TEMPORARY TABLE bounced__session2
SELECT 
	session_w_landing_pages1.website_session_id,
    session_w_landing_pages1.landing_page ,
    COUNT(website_pageviews.website_session_id) AS counts_pagesview2
FROM session_w_landing_pages1
LEFT JOIN website_pageviews	
	ON session_w_landing_pages1.website_session_id = website_pageviews.website_session_id
GROUP BY 
	session_w_landing_pages1.website_session_id,
    session_w_landing_pages1.landing_page
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;

SELECT * FROM bounced__session2;

-- 4
SELECT 
	session_w_landing_pages1.landing_page,
    session_w_landing_pages1.website_session_id,
    bounced__session2.website_session_id AS bounced_website_session_id
FROM session_w_landing_pages1
	LEFT JOIN bounced__session2
    ON bounced__session2.website_session_id = session_w_landing_pages1.website_session_id
ORDER BY
	session_w_landing_pages1.website_session_id;
    
-- 5
SELECT 
	session_w_landing_pages1.landing_page,
    COUNT( DISTINCT session_w_landing_pages1.website_session_id) AS sessions,
    COUNT( DISTINCT bounced__session2.website_session_id) AS bounced_website_session_id,
    COUNT( DISTINCT bounced__session2.website_session_id)/COUNT( DISTINCT session_w_landing_pages1.website_session_id) AS bounced_rates
FROM session_w_landing_pages1
	LEFT JOIN bounced__session2
    ON bounced__session2.website_session_id = session_w_landing_pages1.website_session_id
GROUP BY
	session_w_landing_pages1.landing_page
;


