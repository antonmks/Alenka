LF := FILTER lineitem BY shipdate >= 19950101 AND shipdate <= 19961231;

NF1 := FILTER nation BY n_name == "FRANCE" OR n_name == "GERMANY";
  
SN := SELECT  s_suppkey AS s_suppkey, n_name AS n_name
      FROM supplier JOIN NF1 ON s_nationkey = n_nationkey;

SN1 := SELECT  s_suppkey AS s_suppkey, n_name AS n_name1
      FROM SN;

NF := FILTER nation BY n_name == "FRANCE" OR n_name == "GERMANY";	  
	  
LJ := SELECT suppkey AS suppkey, price AS price, discount AS discount, shipdate AS shipdate, n_name AS n_name
       FROM LF JOIN orders ON orderkey = o_orderkey
	           JOIN customer ON o_custkey = c_custkey
	           JOIN NF ON c_nationkey = n_nationkey;  	   
			   
LS := SELECT price AS price, discount AS discount, n_name1 AS n_name1, shipdate AS shipdate, n_name AS n_name
       FROM LJ JOIN SN1 ON suppkey = s_suppkey;   

   
LF1 := FILTER LS BY (n_name1 == "FRANCE" AND n_name == "GERMANY")
				OR (n_name1 == "GERMANY"  AND n_name == "FRANCE");
				
T := SELECT n_name1 AS n1, n_name AS n2, shipdate/10000 AS shipdate3, price AS price1, discount AS discount1
     FROM LF1;				
	 
G := SELECT n1 AS supp_nation, n2 AS cust_nation, shipdate3 AS shipdate4, SUM(price1*(1-discount1)) AS revenue
     FROM T
     GROUP BY n1, n2, shipdate3; 		
	 

GO := ORDER G BY supp_nation ASC, cust_nation ASC, shipdate4 ASC;	 
				
DISPLAY GO USING ('|');	  
	  


