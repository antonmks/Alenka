C := LOAD 'customer.tbl' USING ('|') AS (c_custkey{1}:int, c_city{4}:varchar(10), c_nation{5}:varchar(15), c_region{6}:varchar(12));
STORE C INTO 'customer' BINARY;