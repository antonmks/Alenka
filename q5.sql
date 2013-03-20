O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int, o_orderdate{5}:int);
OFI := FILTER O BY o_orderdate >= 19940101 AND o_orderdate < 19950101;

R := LOAD 'region' BINARY AS (r_regionkey{1}:int, r_name{2}:varchar(25));
RF := FILTER R BY r_name == "ASIA";

S := LOAD 'supplier' BINARY AS (s_suppkey{1}:int, s_nationkey{4}:int );
N := LOAD 'nation' BINARY AS (n_nationkey{1}:int, n_name{2}:varchar(25), n_regionkey{3}:int);

C := LOAD 'customer' BINARY AS (c_custkey{1}:int, c_nationkey{4}:int);
L := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int,  l_suppkey{3}:int, l_price{6}:decimal, l_discount{7}:decimal);

J_N := SELECT n_name AS n_name, n_nationkey AS n_nationkey
       FROM N JOIN RF ON n_regionkey = r_regionkey;
J_S := SELECT s_nationkey AS s_nationkey, s_suppkey AS s_suppkey, n_name AS n_name 
       FROM S JOIN J_N ON s_nationkey = n_nationkey;

	   
F := SELECT o_custkey AS o_custkey, l_suppkey AS l_suppkey, l_price AS l_price, l_discount AS l_discount 
      FROM L JOIN OFI ON l_orderkey = o_orderkey;
	   
F1 := SELECT  o_custkey AS o_custkey, s_nationkey AS s_nationkey, n_name AS n_name, l_price AS l_price, l_discount AS l_discount
     FROM F JOIN J_S ON l_suppkey = s_suppkey;
	 
  
F2 := SELECT  n_name AS n_name, l_price AS l_price, l_discount AS l_discount
      FROM F1 JOIN C ON o_custkey = c_custkey AND s_nationkey = c_nationkey;
	  
	  
F3 := SELECT n_name AS n_name1, SUM(l_price*(1-l_discount)) AS revenue FROM F2
      GROUP BY n_name;
F4 := ORDER F3 BY revenue DESC;	  

STORE F4 INTO 'mytest.txt' USING ('|');










