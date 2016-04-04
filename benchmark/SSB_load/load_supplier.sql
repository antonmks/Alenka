C := LOAD 'supplier.tbl' USING ('|') AS (s_suppkey{1}:int, s_city{4}:varchar(10), s_nation{6}:varchar(15), s_region{7}:varchar(12));
STORE C INTO 'supplier' BINARY;
