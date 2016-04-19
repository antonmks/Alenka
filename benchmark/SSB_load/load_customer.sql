C := LOAD 'customer.tbl' USING ('|') AS (
	c_custkey{1}:int,
	c_name{2}:varchar(25),
	c_address{3}:varchar(25),
	c_city{4}:varchar(10), 
	c_nation{5}:varchar(15), 
	c_region{6}:varchar(12),
	c_phone{7}:varchar(15),
	c_mktsegment{8}:varchar(10)
);
STORE C INTO 'customer' BINARY;