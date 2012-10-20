A := LOAD 'orders.tbl' USING ('|') AS (orderkey{1}:int, o_custkey{2}:int, orderdate{5}:int, orderpriority{6}:varchar(15), shippriority{8}:int);
STORE A INTO 'orders' BINARY;