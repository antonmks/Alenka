OFI := FILTER orders BY o_orderdate < 19950315;
CF := FILTER customer BY c_mktsegment == "BUILDING";
LF := FILTER lineitem BY shipdate > 19950315;

OLC := SELECT o_orderkey AS o_orderkey, o_orderdate AS o_orderdate, o_shippriority AS o_shippriority, price AS price, discount AS discount 
       FROM LF JOIN OFI ON orderkey = o_orderkey
	           JOIN CF ON o_custkey = c_custkey;
			  
F := SELECT o_orderkey AS o_orderkey1, o_orderdate AS orderdate1, o_shippriority AS shippriority1,
            SUM(price*(1-discount)) AS sum_revenue, COUNT(o_orderkey) AS cnt  FROM OLC 
 	 GROUP BY o_orderkey, o_orderdate, o_shippriority;	
	  
RES := ORDER F BY sum_revenue DESC, orderdate1 ASC;	   
DISPLAY RES USING ('|') LIMIT 10;	