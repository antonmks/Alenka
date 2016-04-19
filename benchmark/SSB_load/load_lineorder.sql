C := LOAD 'lineorder.tbl' USING ('|') AS (
	lo_orderkey{1}:int,
	lo_linenumber{2}:int,
	lo_custkey{3}:int,
	lo_partkey{4}:int,
	lo_suppkey{5}:int,
	lo_orderdatekey{6}:int,
	lo_orderpriority{7}:varchar(15),
	lo_shippriority{8}:varchar(1),
	lo_quantity{9}:int, 
	lo_extendedprice{10}:decimal, 
	lo_ordtotalprice{11}:decimal,
	lo_discount{12}:int,
	lo_revenue{13}:decimal,
	lo_supplycost{14}:decimal,
	lo_tax{15}:int,
	lo_commitdatekey{16}:int,
	lo_shipmode{17}:varchar(10)
);
STORE C INTO 'lineorder' BINARY;
