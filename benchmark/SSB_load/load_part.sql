C := LOAD 'part.tbl' USING ('|') AS (p_partkey{1}:int, p_name{2}:varchar(22), p_mfgr{3}:varchar(6), p_category{4}:varchar(12),
                                       p_brand1{5}:varchar(9));
STORE C INTO 'part' BINARY;
