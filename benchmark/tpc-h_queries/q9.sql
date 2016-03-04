P := FILTER part BY p_name LIKE "%green%";

PS := SELECT ps_supplycost AS ps_supplycost, ps_partkey AS ps_partkey, ps_suppkey AS ps_suppkey
	   FROM partsupp JOIN P ON ps_partkey = p_partkey;	

LP := SELECT price AS price, discount AS discount, qty AS qty, partkey AS partkey, orderkey AS orderkey, suppkey AS suppkey
      FROM lineitem JOIN P ON partkey = p_partkey; 
	  
LS := SELECT price AS price, discount AS discount, qty AS qty, partkey AS partkey, orderkey AS orderkey, suppkey AS suppkey, s_nationkey AS s_nationkey
	  FROM LP JOIN supplier ON suppkey = s_suppkey;	

LPS := SELECT price AS price, discount AS discount, qty AS qty, ps_supplycost AS ps_supplycost, s_nationkey AS s_nationkey,
			orderkey AS orderkey 
		FROM LS JOIN PS ON partkey = ps_partkey AND suppkey = ps_suppkey;

LJS := SELECT price*(1-discount)-(ps_supplycost*qty) AS amount, s_nationkey AS s_nationkey, orderkey AS orderkey FROM LPS;		

LO := SELECT amount AS amount, o_orderdate AS o_orderdate, s_nationkey AS s_nationkey
      FROM orders JOIN LJS ON o_orderkey = orderkey;
	  
LO1 := SELECT amount AS amount, (o_orderdate/10000) AS year, s_nationkey AS s_nationkey FROM LO;			  	  

LN := SELECT amount AS amount, year AS year, n_name AS n_name
	  FROM LO1 JOIN nation ON s_nationkey = n_nationkey;		   
	 
G := SELECT n_name AS n_name1, year AS year1, SUM(amount) AS amount1 FROM LN
     GROUP BY n_name, year;	 
	 
T := ORDER G BY n_name1, year1 DESC;	 

STORE T INTO 'mytest.txt' USING ('|');

