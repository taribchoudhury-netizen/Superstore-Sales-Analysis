# 🛒 Superstore Sales Analysis — SQL Project

## Project Overview

This project performs an end-to-end sales analysis on the Superstore dataset using PostgreSQL.
The goal is to uncover actionable business insights around profitability, customer behaviour,
discount strategy, and regional performance across 9,994 orders from 2011 to 2014.

---

## Tools Used

- **PostgreSQL** — querying and analysis
- **pgAdmin** — database management
- **Excel / CSV** — raw data source

---

## Dataset

| Field | Detail |
|-------|--------|
| Source | Superstore.csv |
| Rows | 9,994 orders |
| Time Period | 2011 – 2014 |
| Columns | 21 (sales, profit, discount, region, category, customer, etc.) |

---

## Key Findings

### 💰 Overall Performance
- Total Sales: **$2,297,200.86**
- Total Profit: **$286,397.02**
- Profit Margin: **12.47%**
- Unique Customers: **793**

### 📦 Category Performance
- **Technology** is the top revenue category at **$836,154.03**
- **Copiers** generate the highest sub-category profit at **$55,617.82** with strong margins
- **Furniture** has the lowest profit margin at just **2.49%**, barely breaking even
- **Tables** are the worst performing sub-category at **-8.56% margin** — every sale loses money

### 🌍 Regional Performance
- **West region** leads in revenue at **$725,457.82**, driven by California
- **California** alone generates **$457,687.63** — the #1 state
- **Central region** has the lowest profit margin at **7.92%**, nearly half of the West's 14.94%

### 👥 Customer Insights
- **Consumer segment** is the most profitable at **$134,119.21** in total profit
- Top 10 customers contribute only **6.70%** of revenue — healthy, low concentration risk
- **395 out of 793 customers (~50%)** drive 80% of total revenue (Pareto analysis)
- The majority of customers are **repeat buyers**, indicating strong loyalty

### 📅 Time Trends
- **2014** was the best year with **$733,947.02** in sales
- Overall **4-year sales growth of ~52%** from 2011 to 2014
- **November** is the best month historically at **$349,120.07** — driven by holiday demand
- Q4 (October–December) consistently outperforms all other quarters

### 🏷️ Discount Strategy
| Discount Level | Avg Profit Per Order |
|---------------|----------------------|
| No Discount | **+$66.90** |
| Low (≤20%) | **+$26.50** |
| Medium (21–50%) | **-$109.53** |
| High (>50%) | **-$89.44** |

Any discount above 20% destroys profitability. The current discount strategy is ineffective.

---

## Business Recommendations

1. **Stop heavy discounting** — Discounts above 20% generate consistent losses across all categories
2. **Discontinue or reprice Tables** — -8.56% margin means every sale is a net loss
3. **Focus on Technology + Consumer segment in the West** — this combination drives maximum profitability
4. **Investigate the Central region** — 7.92% margin needs urgent review of pricing and discount policies
5. **Protect top Quartile 1 customers** — top 25% of customers drive the majority of revenue; invest in retention
6. **Expand the Copiers category** — highest sub-category profit at $55,617.82 with room to grow

---

## SQL Concepts Demonstrated

- Aggregations and GROUP BY
- HAVING clauses and subqueries
- CASE statements
- CTEs (Common Table Expressions)
- Window Functions: RANK(), NTILE(), LAG(), SUM() OVER()
- Running totals and cumulative calculations
- Year-over-year growth analysis
- Pareto / 80-20 analysis
- Customer segmentation and quartile analysis

---

## How to Run

1. Open **pgAdmin** and create a new database
2. Run the `CREATE TABLE` block at the top of `Superstore.sql`
3. Update the file path in the `COPY` command to match your local path
4. Run all queries sequentially
5. Each query includes a comment with the finding underneath it

---

## Project Structure

```
Superstore-Sales-Analysis/
│
├── Superstore.sql       # All 34 queries with findings
├── Superstore.csv       # Raw dataset
└── README.md            # This file
```

---

## Author

**Tarib**  
Aspiring Data Analyst | SQL • Excel • Power BI  
