C := LOAD 'C:\GitHub\DBGen\tpch_2_15.0\dbgen\customer.tbl' USING ('|') AS (c_custkey{1}:int, c_nationkey{4}:int, mktsegment{7}:varchar(10));
STORE C INTO 'C:\db\alenka\100g\customer' BINARY;