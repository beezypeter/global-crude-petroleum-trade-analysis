-- =====================================================================
-- GLOBAL CRUDE PETROLEUM TRADE ANALYSIS (1995-2021)
-- Tool: MySQL
-- Dataset: Worldwide Crude Oil Export and Import Trade
-- =====================================================================

-- 1. ANNUAL GLOBAL TRADE TREND
-- How has global crude petroleum trade changed over time?
SELECT
    `year`,
    SUM(`Trade Value`) AS total_trade
FROM global_crude
GROUP BY `year`
ORDER BY `year`;

-- 2. IMPORT VS EXPORT TRADE BY YEAR
-- How do annual import and export values compare?
SELECT
    `year`,
    SUM(CASE WHEN action = 'Import' THEN `Trade Value` ELSE 0 END) AS total_import,
    SUM(CASE WHEN action = 'Export' THEN `Trade Value` ELSE 0 END) AS total_export
FROM global_crude
GROUP BY `year`
ORDER BY `year`;

-- 3. YEAR-OVER-YEAR GLOBAL TRADE GROWTH
-- What was the percentage change in global trade from each prior year?
WITH yearly_trade AS (
    SELECT `year`, SUM(`Trade Value`) AS total_trade
    FROM global_crude
    GROUP BY `year`
),
trade_change AS (
    SELECT
        `year`,
        total_trade,
        LAG(total_trade) OVER (ORDER BY `year`) AS previous_year_trade
    FROM yearly_trade
)
SELECT
    `year`,
    total_trade,
    previous_year_trade,
    ROUND((total_trade - previous_year_trade) / previous_year_trade * 100, 2)
        AS yoy_percentage_change
FROM trade_change
ORDER BY `year`;

-- 4. LARGEST YEAR-OVER-YEAR TRADE DECLINE
-- Which year experienced the largest percentage decline in global trade?
WITH yearly_trade AS (
    SELECT `year`, SUM(`Trade Value`) AS total_trade
    FROM global_crude
    GROUP BY `year`
),
trade_change AS (
    SELECT
        `year`,
        total_trade,
        LAG(total_trade) OVER (ORDER BY `year`) AS previous_year_trade
    FROM yearly_trade
),
percentage_change AS (
    SELECT
        `year`,
        total_trade,
        previous_year_trade,
        (total_trade - previous_year_trade) / previous_year_trade * 100
            AS yoy_percentage_change
    FROM trade_change
)
SELECT
    `year`,
    total_trade,
    previous_year_trade,
    ROUND(yoy_percentage_change, 2) AS yoy_percentage_change
FROM percentage_change
WHERE previous_year_trade IS NOT NULL
ORDER BY yoy_percentage_change
LIMIT 1;

-- 5. TOP 10 COUNTRIES BY TOTAL TRADE
-- Which countries generated the highest trade value across 1995-2021?
SELECT
    country,
    SUM(`Trade Value`) AS total_trade
FROM global_crude
GROUP BY country
ORDER BY total_trade DESC
LIMIT 10;

-- 6. HIGHEST-TRADING COUNTRY IN EACH YEAR
-- Which country recorded the highest total trade value in each year?
WITH country_year_trade AS (
    SELECT
        `year`,
        country,
        SUM(`Trade Value`) AS total_trade,
        ROW_NUMBER() OVER (
            PARTITION BY `year`
            ORDER BY SUM(`Trade Value`) DESC
        ) AS trade_rank
    FROM global_crude
    GROUP BY `year`, country
)
SELECT `year`, country, total_trade
FROM country_year_trade
WHERE trade_rank = 1
ORDER BY `year`;

-- 7. MOST FREQUENT ANNUAL TRADE LEADER
-- Which country appeared as the highest-trading country most often?
WITH country_year_trade AS (
    SELECT
        `year`,
        country,
        SUM(`Trade Value`) AS total_trade,
        ROW_NUMBER() OVER (
            PARTITION BY `year`
            ORDER BY SUM(`Trade Value`) DESC
        ) AS trade_rank
    FROM global_crude
    GROUP BY `year`, country
),
annual_leaders AS (
    SELECT `year`, country
    FROM country_year_trade
    WHERE trade_rank = 1
)
SELECT
    country,
    COUNT(*) AS years_as_trade_leader
FROM annual_leaders
GROUP BY country
ORDER BY years_as_trade_leader DESC;

-- 8. COUNTRIES WITH AN EXPORT SURPLUS
-- Which countries exported more crude petroleum than they imported?
WITH country_trade AS (
    SELECT
        country,
        SUM(CASE WHEN action = 'Export' THEN `Trade Value` ELSE 0 END) AS total_export,
        SUM(CASE WHEN action = 'Import' THEN `Trade Value` ELSE 0 END) AS total_import
    FROM global_crude
    GROUP BY country
)
SELECT
    country,
    total_export,
    total_import,
    total_export - total_import AS export_surplus
FROM country_trade
WHERE total_export > total_import
ORDER BY export_surplus DESC;

-- 9. CONTINENT IMPORT VS EXPORT ANALYSIS
-- How do import and export values compare across continents?
SELECT
    continent,
    SUM(CASE WHEN action = 'Import' THEN `Trade Value` ELSE 0 END) AS total_import,
    SUM(CASE WHEN action = 'Export' THEN `Trade Value` ELSE 0 END) AS total_export,
    SUM(CASE WHEN action = 'Export' THEN `Trade Value` ELSE 0 END)
      - SUM(CASE WHEN action = 'Import' THEN `Trade Value` ELSE 0 END) AS trade_balance
FROM global_crude
GROUP BY continent
ORDER BY total_import + total_export DESC;

-- 10. HIGHEST-TRADING COUNTRY IN EACH CONTINENT
-- Which country contributed the most trade within each continent?
WITH country_trade AS (
    SELECT
        continent,
        country,
        SUM(`Trade Value`) AS total_trade,
        ROW_NUMBER() OVER (
            PARTITION BY continent
            ORDER BY SUM(`Trade Value`) DESC
        ) AS trade_rank
    FROM global_crude
    GROUP BY continent, country
)
SELECT continent, country, total_trade
FROM country_trade
WHERE trade_rank = 1
ORDER BY continent;

-- 11. TOP 3 COUNTRIES WITHIN EACH CONTINENT
-- Which three countries contributed the most within each continent,
-- and what percentage of continental trade did each represent?
WITH continent_country_trade AS (
    SELECT
        continent,
        country,
        SUM(`Trade Value`) AS country_total_trade,
        SUM(SUM(`Trade Value`)) OVER (PARTITION BY continent) AS continent_total_trade,
        ROW_NUMBER() OVER (
            PARTITION BY continent
            ORDER BY SUM(`Trade Value`) DESC
        ) AS trade_rank
    FROM global_crude
    GROUP BY continent, country
)
SELECT
    continent,
    country,
    country_total_trade,
    continent_total_trade,
    ROUND(country_total_trade / continent_total_trade * 100, 2)
        AS percentage_of_continent_trade,
    trade_rank
FROM continent_country_trade
WHERE trade_rank <= 3
ORDER BY continent, trade_rank;

-- 12. LARGEST PERCENTAGE GROWTH FROM 2020 TO 2021
-- Which countries experienced the largest percentage growth in trade?
WITH country_trade AS (
    SELECT
        country,
        SUM(CASE WHEN `year` = 2020 THEN `Trade Value` ELSE 0 END) AS trade_2020,
        SUM(CASE WHEN `year` = 2021 THEN `Trade Value` ELSE 0 END) AS trade_2021
    FROM global_crude
    GROUP BY country
)
SELECT
    country,
    trade_2020,
    trade_2021,
    ROUND((trade_2021 - trade_2020) / trade_2020 * 100, 2) AS percentage_growth
FROM country_trade
WHERE trade_2020 > 0
  AND trade_2021 > 0
ORDER BY percentage_growth DESC;

-- 13. LARGEST ABSOLUTE GROWTH FROM 2020 TO 2021
-- Which countries experienced the largest increase in actual trade value?
WITH country_trade AS (
    SELECT
        country,
        SUM(CASE WHEN `year` = 2020 THEN `Trade Value` ELSE 0 END) AS trade_2020,
        SUM(CASE WHEN `year` = 2021 THEN `Trade Value` ELSE 0 END) AS trade_2021
    FROM global_crude
    GROUP BY country
)
SELECT
    country,
    trade_2020,
    trade_2021,
    trade_2021 - trade_2020 AS absolute_growth
FROM country_trade
WHERE trade_2020 > 0
  AND trade_2021 > 0
ORDER BY absolute_growth DESC;

-- 14. COUNTRY TRADE CHANGE CLASSIFICATION: 2020 VS 2021
-- How many countries increased, decreased, or recorded no change?
WITH country_trade AS (
    SELECT
        country,
        SUM(CASE WHEN `year` = 2020 THEN `Trade Value` ELSE 0 END) AS trade_2020,
        SUM(CASE WHEN `year` = 2021 THEN `Trade Value` ELSE 0 END) AS trade_2021
    FROM global_crude
    GROUP BY country
),
trade_status AS (
    SELECT
        country,
        CASE
            WHEN trade_2021 > trade_2020 THEN 'Increased'
            WHEN trade_2021 < trade_2020 THEN 'Decreased'
            ELSE 'No Change'
        END AS status
    FROM country_trade
)
SELECT
    status,
    COUNT(*) AS number_of_countries
FROM trade_status
GROUP BY status
ORDER BY number_of_countries DESC;

-- 15. PERCENTAGE OF COUNTRIES GROWING BY CONTINENT
-- What percentage of countries in each continent increased their total
-- trade value from 2020 to 2021?
WITH country_trade AS (
    SELECT
        continent,
        country,
        SUM(CASE WHEN `year` = 2020 THEN `Trade Value` ELSE 0 END) AS trade_2020,
        SUM(CASE WHEN `year` = 2021 THEN `Trade Value` ELSE 0 END) AS trade_2021
    FROM global_crude
    GROUP BY continent, country
),
trade_status AS (
    SELECT
        continent,
        country,
        CASE
            WHEN trade_2021 > trade_2020 THEN 'Increased'
            WHEN trade_2021 < trade_2020 THEN 'Decreased'
            ELSE 'No Change'
        END AS status
    FROM country_trade
)
SELECT
    continent,
    COUNT(*) AS total_countries,
    SUM(CASE WHEN status = 'Increased' THEN 1 ELSE 0 END) AS increased_countries,
    ROUND(
        SUM(CASE WHEN status = 'Increased' THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS percentage_increased
FROM trade_status
GROUP BY continent
ORDER BY percentage_increased DESC;
