-- Step 1: DDW -Create star schema tables
.read 2_DW_Mart_Build/01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into tables
.read 2_DW_Mart_Build/02_load_schema_dw.sql
