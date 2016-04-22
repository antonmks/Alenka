C := LOAD 'supplier.tbl' USING ('|') AS (
	s_suppkey{1}:int, 
	s_name{2}:varchar(25),
	s_address{3}:varchar(25),
	s_city{4}:varchar(10), 
	s_nation{5}:varchar(15), 
	s_region{6}:varchar(12),
	s_phone{7}:varchar(15)
);
STORE C INTO 'supplier' BINARY;
