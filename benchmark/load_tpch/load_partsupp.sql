A  :=  LOAD 'partsupp1000.tbl' USING ('|') AS (ps_partkey{1}:int, ps_suppkey{2}:int, ps_availqty{3}:int, ps_supplycost{4}:decimal);
STORE A INTO 'partsupp' BINARY;