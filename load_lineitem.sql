A := LOAD 'lineitem.tbl' USING ('|') AS (orderkey{1}:int REFERENCES orders(1), partkey{2}:int, suppkey{3}:int, quantity{5}:int,
price{6}:decimal, discount{7}:decimal, tax{8}:decimal, returnflag{9}:varchar(1), linestatus{10}:varchar(1), shipdate{11}:int);
STORE A INTO 'lineitem' BINARY;