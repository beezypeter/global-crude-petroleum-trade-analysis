# Global Crude Petroleum Trade Analysis (1995–2021)

## Project Overview

This project analyzes global crude petroleum trade data from 1995 to 2021 using MySQL. The analysis explores long-term trade trends, import and export activity, country and continental performance, year-over-year changes, and shifts in crude petroleum trade between 2020 and 2021.

The goal is to demonstrate practical SQL analysis: moving from raw trade records to clear, decision-relevant insights using aggregation, CTEs, conditional logic, and window functions.

## Dataset

The dataset contains **7,925 records** with five fields:

| Column | Description |
|---|---|
| `Continent` | Continent associated with the country |
| `Country` | Country involved in the trade |
| `Trade Value` | Monetary value of crude petroleum trade |
| `Year` | Year of the trade record |
| `Action` | Trade direction: Import or Export |

**Source:** [Worldwide Crude Oil Export and Import Trade — Kaggle](https://www.kaggle.com/datasets/toriqulstu/global-crude-petroleum-trade-1995-2021)

## Tools & SQL Skills

**Tools:** MySQL, MySQL Workbench

**Techniques demonstrated:** `GROUP BY`, `CASE`, conditional aggregation, CTEs, subqueries, `ROW_NUMBER()`, `LAG()`, `PARTITION BY`, multi-level aggregation, ranking, year-over-year analysis, and percentage calculations.

## Analytical Questions

1. How has global crude petroleum trade changed over time?
2. How do global imports and exports compare by year?
3. What was the year-over-year percentage change in global trade?
4. Which year experienced the largest percentage decline?
5. Which countries generated the highest total trade value?
6. Which country recorded the highest trade value in each year?
7. Which country appeared as the annual trade leader most often?
8. Which countries recorded an export surplus across the full period?
9. How do total imports and exports compare across continents?
10. Which country contributed the most trade within each continent?
11. Which three countries contributed the most within each continent, and what share did they represent?
12. Which countries recorded the largest percentage growth from 2020 to 2021?
13. Which countries recorded the largest absolute growth from 2020 to 2021?
14. How many countries increased, decreased, or showed no change from 2020 to 2021?
15. What percentage of countries in each continent experienced trade growth from 2020 to 2021?

## Key Findings

- Global crude petroleum trade reached its highest level in **2012**.
- **2000** recorded the largest year-over-year percentage increase, approximately **78.34%**.
- **2015** recorded the largest year-over-year percentage decline, approximately **44.80%**.
- The **United States** recorded the largest absolute increase in trade value between 2020 and 2021.
- **Morocco** showed an exceptionally large percentage increase from 2020 to 2021. Investigation showed that the percentage was amplified by a very small 2020 trade base, illustrating why percentage growth should be interpreted alongside absolute values.
- Global import and export values were almost perfectly balanced. At two decimal places, exports represented approximately **50.00%** of global trade each year. Inspecting the underlying totals confirmed that this was a feature of the dataset rather than a SQL calculation error.

## Analytical Approach

The analysis starts with global trends, then moves into country- and continent-level performance. Window functions are used to compare annual performance and rank countries within groups, while conditional aggregation is used to compare imports and exports and classify changes in trade performance.

The final analyses focus on 2020–2021 to show the difference between percentage growth and absolute growth and to measure how broadly trade growth was distributed across continents.

## Repository Structure

```text
global-crude-petroleum-trade-analysis/
├── README.md
├── global_crude_analysis.sql
├── data/
│   └── Global_Crude_Petroleum_Trade_1995_2021.csv
└── images/
    └── query_results/
```

## SQL Analysis

The complete set of 15 portfolio queries is available in [`global_crude_analysis.sql`](global_crude_analysis.sql).

## Notes

Trade values are analyzed as provided in the source dataset. Results should therefore be interpreted as analysis of the supplied dataset rather than as independently verified official trade statistics.
