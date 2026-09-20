# Global Crude Petroleum Trade Analysis (1995–2021)

## Project Overview

This project analyzes **7,925 records** of global crude petroleum trade from 1995 to 2021 using MySQL. The analysis moves from global trends to country- and continent-level performance, with a final focus on trade changes between 2020 and 2021.

The project demonstrates how SQL can be used to turn raw trade records into clear analytical findings using aggregation, conditional logic, CTEs, and window functions.

## Dataset

| Column | Description |
|---|---|
| `Continent` | Continent associated with the country |
| `Country` | Country involved in the trade |
| `Trade Value` | Monetary value of crude petroleum trade |
| `Year` | Year of the trade record |
| `Action` | Trade direction: Import or Export |

**Source:** [Worldwide Crude Oil Export and Import Trade — Kaggle](https://www.kaggle.com/datasets/toriqulstu/global-crude-petroleum-trade-1995-2021)

The raw dataset is not duplicated in this repository. See [`data/README.md`](data/README.md) for the source and expected schema.

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
14. How many active countries increased, decreased, or showed no change from 2020 to 2021?
15. What percentage of active countries in each continent experienced trade growth from 2020 to 2021?

## Key Findings

- Global crude petroleum trade peaked in **2012**, at approximately **3.16 trillion** in the dataset's trade-value units.
- **2000** recorded the largest year-over-year percentage increase, approximately **78.34%**.
- **2015** recorded the largest year-over-year percentage decline, approximately **44.80%**.
- The **United States** had the highest cumulative trade value across the full period, approximately **4.30 trillion**, and ranked as the annual trade leader in **22 of 27 years**.
- The **United States** also recorded the largest absolute increase from 2020 to 2021, approximately **60.70 billion**.
- **Morocco** recorded the largest percentage increase from 2020 to 2021, but its approximately **2.70 million%** growth rate was driven by a very small 2020 base. This illustrates why percentage growth should be interpreted alongside absolute values.
- Global imports and exports were almost perfectly balanced. Exports represented approximately **50.00%** of global trade in every year when rounded to two decimal places.
- Among countries with trade activity in 2020 or 2021, **Europe** had the highest share of countries with increased trade: **35 of 40 countries (87.50%)**.

## Analytical Approach

The analysis starts with annual global trade and import/export patterns, then uses window functions to measure year-over-year change and identify annual leaders. Country- and continent-level analyses use conditional aggregation and partitioned ranking to compare performance within groups.

The final section compares 2020 with 2021. Countries are included in the classification analysis when they have trade activity in at least one of those two years, avoiding the classification of countries absent from both years as "No Change."

## Selected Result Tables

Reproducible extracts from the analysis are included in the [`results/`](results/) folder:

- [Top 10 countries by total trade](results/top_10_countries_by_total_trade.csv)
- [Annual trade-leader frequency](results/annual_trade_leader_frequency.csv)
- [2020–2021 growth by continent](results/continent_growth_2020_2021.csv)

## Repository Structure

```text
global-crude-petroleum-trade-analysis/
├── README.md
├── global_crude_analysis.sql
├── LICENSE
├── data/
│   └── README.md
└── results/
    ├── top_10_countries_by_total_trade.csv
    ├── annual_trade_leader_frequency.csv
    └── continent_growth_2020_2021.csv
```

## SQL Analysis

The complete set of **15 portfolio queries** is available in [`global_crude_analysis.sql`](global_crude_analysis.sql).

## Notes

Trade values are analyzed exactly as supplied by the source dataset and are not independently verified official statistics. The repository focuses on SQL methodology, analytical reasoning, and reproducible findings.
