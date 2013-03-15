N := LOAD 'nation' BINARY AS (n_nationkey{1}:int, n_name{2}:varchar(25), n_regionkey{3}:int);

R := LOAD 'region' BINARY AS (r_regionkey{1}:int, r_name{2}:varchar(25));
RF := FILTER R BY r_name == "EUROPE";

S := LOAD 'supplier10' BINARY AS (s_suppkey{1}:int, s_name{2}:varchar(25), s_address{3}:varchar(40), s_nationkey{4}:int, s_phone{5}:varchar(15), s_acctbal{6}:decimal, s_comment{7}:varchar(101));

PS := LOAD 'partsupp10' BINARY AS ( ps_partkey{1}:int, ps_suppkey{2}:int, ps_supplycost{4}:decimal);

J_N := SELECT n_nationkey AS n_nationkey, n_name AS n_name
       FROM N JOIN RF ON n_regionkey = r_regionkey;

	   
J_S := SELECT n_name AS n_name, s_suppkey AS s_suppkey,  s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment
       FROM S JOIN J_N ON s_nationkey = n_nationkey;	   

J_PS := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment
        FROM PS JOIN J_S ON ps_suppkey = s_suppkey;
		
PS1 := SELECT ps_partkey AS ps_partkey1, MIN(ps_supplycost) AS ps_supplycost1 FROM J_PS
       GROUP BY ps_partkey;
	   
P := LOAD 'part10' BINARY AS (p_partkey{1}:int, p_mfgr{3}:varchar(25), p_type{5}:varchar(25), p_size{6}:int);	   
PF := FILTER P BY p_type == "%BRASS" AND p_size == 15;

J_PS1 := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment
         FROM J_PS JOIN PF ON ps_partkey = p_partkey;
		 
F := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment 
     FROM J_PS1 JOIN PS1 ON ps_partkey = ps_partkey1 AND ps_supplycost = ps_supplycost1;
	 
STORE F INTO 'mytest1.txt' USING ('|');	   	   	 
	 
FO := ORDER F BY s_acctbal DESC, n_name ASC, s_name ASC, ps_partkey ASC;	

   
STORE FO INTO 'mytest.txt' USING ('|') LIMIT 100;


