A  :=  LOAD 'nation.tbl' USING ('|') AS (
	n_nationkey{1}:int,
	n_name{2}:varchar(25),
	n_regionkey{3}:int
);
STORE A INTO 'nation' BINARY;
