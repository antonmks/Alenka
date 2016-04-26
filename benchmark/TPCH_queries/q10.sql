OFI := FILTER orders BY o_orderdate >= 19931001 AND o_orderdate < 19940101;
LF := FILTER lineitem BY returnflag == "R";

OLC := SELECT c_custkey AS c_custkey, c_name AS c_name, c_acctbal AS c_acctbal, n_name AS n_name,
			  c_address AS c_address, c_phone AS c_phone, c_comment AS c_comment, price AS price, discount AS discount 
       FROM LF JOIN OFI ON orderkey = o_orderkey
	           JOIN customer ON o_custkey = c_custkey
			   JOIN nation ON c_nationkey = n_nationkey;
			  
F := SELECT c_custkey AS c_custkey, c_name AS c_name, c_acctbal AS c_acctbal, n_name AS n_name,
			  c_address AS c_address, c_phone AS c_phone, c_comment AS c_comment, SUM(price*(1-discount)) AS revenue
             FROM OLC 
 	 GROUP BY c_custkey, c_name, c_acctbal, c_phone, n_name, c_address, c_comment;	
	  
RES := ORDER F BY revenue DESC;	   
STORE RES INTO 'q10.txt' USING ('|')  LIMIT 20;
