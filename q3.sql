O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int, o_orderdate{5}:int, o_shippriority{8}:int);
OFI := FILTER O BY o_orderdate < 19950315;
C := LOAD 'customer' BINARY AS (c_custkey{1}:int, c_mktsegment{7}:varchar(10));
CF := FILTER C BY c_mktsegment == "BUILDING";
L := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int,  price{6}:decimal, discount{7}:decimal, shipdate{11}:int);
LF := FILTER L BY shipdate > 19950315;

OLC := SELECT o_orderkey AS o_orderkey, o_orderdate AS o_orderdate, o_shippriority AS o_shippriority, price AS price, discount AS discount 
       FROM LF JOIN OFI ON l_orderkey = o_orderkey
	           JOIN CF ON o_custkey = c_custkey;
			  
F := SELECT o_orderkey AS o_orderkey1, o_orderdate AS orderdate1, o_shippriority AS shippriority1,
            SUM(price*(1-discount)) AS sum_revenue, COUNT(o_orderkey) AS cnt  FROM OLC 
 	 GROUP BY o_orderkey, o_orderdate, o_shippriority;	
	  
RES := ORDER F BY sum_revenue DESC, orderdate1 ASC;	   
STORE RES INTO 'mytest.txt' USING ('|') LIMIT 10;	