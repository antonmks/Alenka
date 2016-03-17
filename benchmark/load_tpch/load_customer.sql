C := LOAD 'customer.tbl' USING ('|') AS (c_custkey{1}:int, c_name{2}:varchar(25), c_address{3}:varchar(40), c_nationkey{4}:int, c_phone{5}:varchar(15),
										c_acctbal{6}:decimal, c_mktsegment{7}:varchar(10), c_comment{8}:varchar(117));
STORE C INTO 'customer' BINARY PRESORTED BY c_custkey;

