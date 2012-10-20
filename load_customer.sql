C := LOAD 'customer.tbl' USING ('|') AS (c_custkey{1}:int, c_nationkey{4}:int, mktsegment{7}:varchar(10));
STORE C INTO 'customer' BINARY;