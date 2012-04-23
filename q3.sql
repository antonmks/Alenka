O := LOAD 'orders10' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int, orderdate{5}:int, shippriority{8}:int);
OFI := FILTER O BY orderdate < 19950315;
C := LOAD 'customer10' BINARY AS (c_custkey{1}:int, mktsegment{7}:varchar(10));
CF := FILTER C BY mktsegment == "BUILDING";
L := STREAM 'lineitem10' BINARY AS (l_orderkey{1}:int,  price{6}:decimal, discount{7}:decimal, shipdate{11}:int);
LF := FILTER L BY shipdate > 19950315;
OL := SELECT  o_orderkey AS o_orderkey, orderdate AS orderdate, shippriority AS shippriority
      FROM OFI JOIN CF ON o_custkey = c_custkey;  
OLC := SELECT o_orderkey AS o_orderkey, orderdate AS orderdate, shippriority AS shippriority, price AS price, discount AS discount 
       FROM LF JOIN OL ON l_orderkey = o_orderkey;
F := SELECT o_orderkey AS o_orderkey, orderdate AS orderdate, 
             SUM(price*(1-discount)) AS sum_revenue, shippriority AS shippriority, COUNT(o_orderkey) AS cnt  FROM OLC 
 	  GROUP BY o_orderkey, orderdate, shippriority;			  
RES := ORDER F BY sum_revenue DESC, orderdate ASC;	   
STORE RES INTO 'mytest.txt' USING ('|') LIMIT 10;	   