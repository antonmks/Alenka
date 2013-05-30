R := LOAD 'region' BINARY AS (r_regionkey{1}:int, r_name{2}:varchar(25));
RF := FILTER R BY r_name == "ASIA";

N := LOAD 'nation' BINARY AS (n_nationkey{1}:int, n_name{2}:varchar(25), n_regionkey{3}:int);

O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int, o_orderdate{5}:int);
OFI := FILTER O BY o_orderdate >= 19940101 AND o_orderdate < 19950101;

S := LOAD 'supplier' BINARY AS (s_suppkey{1}:int, s_nationkey{4}:int );	   
C := LOAD 'customer' BINARY AS (c_custkey{1}:int, c_nationkey{4}:int);
L := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int,  l_suppkey{3}:int, l_price{6}:decimal, l_discount{7}:decimal);

   
J1 := SELECT c_nationkey AS c_nationkey, n_name AS n_name, l_suppkey AS l_suppkey, l_price AS l_price, l_discount AS l_discount
      FROM L JOIN OFI ON l_orderkey = o_orderkey
             JOIN C ON o_custkey = c_custkey
             JOIN N ON c_nationkey = n_nationkey
	         JOIN RF ON n_regionkey = r_regionkey;

J2 := SELECT n_name AS n_name, l_price AS l_price, l_discount AS l_discount
      FROM J1 JOIN S ON l_suppkey = s_suppkey AND c_nationkey = s_nationkey;
	  
F := SELECT n_name AS n_name1, SUM(l_price*(1-l_discount)) AS revenue FROM J2
      GROUP BY n_name;
	  
F1 := ORDER F BY revenue DESC;	  

STORE F1 INTO 'mytest.txt' USING ('|');









