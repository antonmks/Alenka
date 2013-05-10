L  := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int,  commitdate{12}:int, receiptdate{13}:int);
LF := FILTER L BY commitdate < receiptdate;
	  
O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, orderdate{5}:int, orderpriority{6}:varchar(15));	  
OF := FILTER O BY orderdate >= 19930701 AND orderdate < 19931001;

J := SELECT orderpriority AS orderpriority, o_orderkey AS o_orderkey FROM LF
     JOIN OF ON l_orderkey = o_orderkey;

JG := SELECT orderpriority AS orderpriority1, COUNT(orderpriority) AS cnt
      FROM J GROUP BY orderpriority;
	  
JO := ORDER JG BY orderpriority1 ASC;
	  
STORE JO INTO 'mytest.txt' USING ('|');	   



