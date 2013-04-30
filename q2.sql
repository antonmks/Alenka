N := LOAD 'nation' BINARY AS (n_nationkey{1}:int, n_name{2}:varchar(25), n_regionkey{3}:int);

R := LOAD 'region' BINARY AS (r_regionkey{1}:int, r_name{2}:varchar(25));
RF := FILTER R BY r_name == "EUROPE";

S := LOAD 'supplier' BINARY AS (s_suppkey{1}:int, s_name{2}:varchar(25), s_address{3}:varchar(40), s_nationkey{4}:int, s_phone{5}:varchar(15), s_acctbal{6}:decimal, s_comment{7}:varchar(101));

PS := LOAD 'partsupp' BINARY AS ( ps_partkey{1}:int, ps_suppkey{2}:int, ps_supplycost{4}:decimal);

J_PS := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment
        FROM PS JOIN S ON ps_suppkey = s_suppkey
		        JOIN N ON s_nationkey = n_nationkey
                JOIN RF ON n_regionkey = r_regionkey;	   
		
PS1 := SELECT ps_partkey AS ps_partkey1, MIN(ps_supplycost) AS ps_supplycost1 FROM J_PS
       GROUP BY ps_partkey;
	   
P := LOAD 'part' BINARY AS (p_partkey{1}:int, p_mfgr{3}:varchar(25), p_type{5}:varchar(25), p_size{6}:int);	   
PF := FILTER P BY p_type == "%BRASS" AND p_size == 15;
	 
F := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment 
     FROM PS1 JOIN J_PS ON ps_partkey1 = ps_partkey AND ps_supplycost1 = ps_supplycost
	          JOIN PF ON ps_partkey = p_partkey; 
	 
FO := ORDER F BY s_acctbal DESC, n_name ASC, s_name ASC, ps_partkey ASC;	

   
STORE FO INTO 'mytest.txt' USING ('|') LIMIT 100;


