C := LOAD 'part.tbl' USING ('|') AS (p_partkey{1}:int, p_name{2}:varchar(55), p_mfgr{3}:varchar(25), p_brand{4}:varchar(10), p_type{5}:varchar(25), p_size{6}:int,
p_container{7}:varchar(10));
STORE C INTO 'part' BINARY;
