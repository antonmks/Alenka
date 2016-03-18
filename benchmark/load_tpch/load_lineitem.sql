A := LOAD 'lineitem.tbl' USING ('|') AS (orderkey{1}:int , partkey{2}:int, suppkey{3}:int, linenumber{4}:int, qty{5}:int,
price{6}:decimal(10,2), discount{7}:decimal(10,2), tax{8}:decimal(10,2), returnflag{9}:varchar(1), linestatus{10}:varchar(1), shipdate{11}:int,
commitdate{12}:int, receiptdate{13}:int	);
STORE A INTO 'lineitem' BINARY SORT SEGMENTS BY orderkey;