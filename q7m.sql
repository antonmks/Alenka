L := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int, l_suppkey{3}:int, price{6}:decimal, discount{7}:decimal, shipdate{11}:int);
LF := FILTER L BY shipdate >= 19950101 AND shipdate <= 19961231;

S := LOAD 'supplier' BINARY AS (s_suppkey{1}:int, s_nationkey{4}:int);

C := LOAD 'customer' BINARY AS (c_custkey{1}:int, c_nationkey{4}:int);

N := LOAD 'nation' BINARY AS (n_nationkey{1}:int, n_name{2}:varchar(25));
NF := FILTER N BY n_name == "FRANCE" OR n_name == "GERMANY";

N1 := LOAD 'nation' BINARY AS (n_nationkey1{1}:int, n_name1{2}:varchar(25));
NF1 := FILTER N1 BY n_name1 == "FRANCE" OR n_name1 == "GERMANY";

O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int);

  
SN := SELECT  s_suppkey AS s_suppkey, n_name1 AS n_name1
      FROM S JOIN NF1 ON s_nationkey = n_nationkey1;
	  
	  
LJ := SELECT l_suppkey AS l_suppkey, price AS price, discount AS discount, shipdate AS shipdate, n_name AS n_name
       FROM LF JOIN O ON l_orderkey = o_orderkey
	           JOIN C ON o_custkey = c_custkey
	           JOIN NF ON c_nationkey = n_nationkey;  	   

LS := SELECT price AS price, discount AS discount, n_name1 AS n_name1, shipdate AS shipdate, n_name AS n_name
       FROM LJ JOIN SN ON l_suppkey = s_suppkey;
   
LF := FILTER LS BY (n_name1 == "FRANCE" AND n_name == "GERMANY")
				OR (n_name1 == "GERMANY"  AND n_name == "FRANCE");
				
T := SELECT n_name1 AS n1, n_name AS n2, shipdate/10000 AS shipdate3, price AS price1, discount AS discount1
     FROM LF;				
	 
G := SELECT n1 AS supp_nation, n2 AS cust_nation, shipdate3 AS shipdate4, SUM(price1*(1-discount1)) AS revenue
     FROM T
     GROUP BY n1, n2, shipdate3; 		
	 

GO := ORDER G BY supp_nation ASC, cust_nation ASC, shipdate4 ASC;	 
				
STORE GO INTO 'mytest.txt' USING ('|');	  
	  


