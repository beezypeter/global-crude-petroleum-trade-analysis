# Dataset

This project uses the **Worldwide Crude Oil Export and Import Trade (1995–2021)** dataset published on Kaggle.

Source: https://www.kaggle.com/datasets/toriqulstu/global-crude-petroleum-trade-1995-2021

## Expected schema

| Column | Type used in analysis |
|---|---|
| Continent | Text |
| Country | Text |
| Trade Value | Numeric |
| Year | Integer |
| Action | Text (Import / Export) |

The analysis was performed on 7,925 rows. The raw dataset is not redistributed here; download it from the source above and import it into MySQL as a table named `global_crude` to reproduce the queries.
