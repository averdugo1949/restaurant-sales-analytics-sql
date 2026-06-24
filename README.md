## Project Files

- schema.sql: Creates the database tables
- views.sql: Creates reusable summary views
- validation_queries.sql: Checks row counts, relationships, and calculation accuracy
- analysis_queries.sql: Contains business analysis queries
- data/: Contains the CSV files used for import

## Skills Demonstrated

- CREATE TABLE
- Primary keys and foreign keys
- CSV import
- INNER JOIN and LEFT JOIN
- GROUP BY
- SUM, COUNT, AVG
- CASE
- COALESCE
- NULLIF
- Views
- Data validation queries

## Business Questions Answered

- Which employees generated the most sales?
- Which employees earned the most tips?
- Which menu items sold the most?
- Which menu categories generated the most revenue?
- Which employees sold the most wine?
- Which shift types generated the most revenue?
- Which weekdays performed best?
- Which employees had the highest revenue per hour?

## How to Run

1. Run schema.sql to create the tables.
2. Import CSV files from the data folder in this order:
   - employees.csv
   - menu_items.csv
   - shifts.csv
   - sales.csv
3. Run validation_queries.sql to check the data.
4. Run views.sql to create reusable views.
5. Run analysis_queries.sql to run the business analysis.

## Sample Insights

- Revenue can be compared by employee, menu category, shift type, and weekday.
- Wine sales can be isolated to support sales contest-style reporting.
- Revenue per hour gives a fairer comparison than total sales alone.
- Views make repeated analysis easier by summarizing employee and menu performance.