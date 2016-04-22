RF := FILTER region BY r_name == "EUROPE";

PF := FILTER part BY p_type LIKE "%BRASS" AND p_size == 15;

T := SELECT ps_partkey AS ps_partkey, ps_suppkey AS ps_suppkey, ps_supplycost AS ps_supplycost
     FROM partsupp JOIN PF ON ps_partkey = p_partkey; 

J_PS := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment
        FROM T JOIN supplier ON ps_suppkey = s_suppkey 
			   JOIN nation ON s_nationkey = n_nationkey
			   JOIN RF ON n_regionkey = r_regionkey;

PS1 := SELECT ps_partkey AS ps_partkey1, MIN(ps_supplycost) AS ps_supplycost1 FROM J_PS
       GROUP BY ps_partkey;	   	   
   
F := SELECT n_name AS n_name, ps_partkey AS ps_partkey, ps_supplycost AS ps_supplycost, s_name AS s_name, s_address AS s_address,  s_nationkey AS s_nationkey, s_phone AS s_phone, s_acctbal AS s_acctbal, s_comment AS s_comment 
     FROM PS1 JOIN J_PS ON ps_partkey1 = ps_partkey AND ps_supplycost1 = ps_supplycost;	
	 
FO := ORDER F BY s_acctbal DESC, n_name ASC, s_name ASC, ps_partkey ASC;	

STORE FO INTO 'mytest.txt' USING ('|') LIMIT 100;   


