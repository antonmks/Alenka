A  :=  LOAD 'region.tbl' USING ('|') AS (r_regionkey{1}:int, r_name{2}:varchar(25));
STORE A INTO 'region' BINARY;