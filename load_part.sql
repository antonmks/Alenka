C := LOAD 'part.tbl' USING ('|') AS (p_partkey{1}:int, p_mfgr{3}:varchar(25), p_type{5}:varchar(25), p_size{6}:int);
STORE C INTO 'part' BINARY;
