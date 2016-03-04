C := LOAD 'lineorder.tbl' USING ('|') AS (lo_orderkey{1}:int, lo_custkey{3}:int, lo_partkey{4}:int, lo_suppkey{5}:int, lo_orderdate{6}:int, 
                                            lo_quantity{9}:int, lo_extendedprice{10}:decimal, lo_discount{12}:int,
 					lo_revenue{13}:decimal, lo_supplycost{14}:decimal, tax{15}:int);
STORE C INTO 'lineorder' BINARY;
