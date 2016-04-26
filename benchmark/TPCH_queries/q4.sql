OFI := FILTER orders BY o_orderdate >= 19930701 AND o_orderdate < 19931001;
LF := FILTER lineitem BY commitdate < receiptdate;

OLC := SELECT o_orderkey AS o_orderkey, o_orderpriority AS o_orderpriority
       FROM LF JOIN OFI ON orderkey = o_orderkey;
	   
F := SELECT o_orderkey AS o_orderkey1, o_orderpriority AS orderpriority1
     FROM OLC 
     GROUP BY o_orderkey, o_orderpriority;	

F1 := SELECT orderpriority1 AS op, COUNT(o_orderkey1) AS cnt
      FROM F
      GROUP BY orderpriority1;	

F2 := ORDER F1 BY op ASC;	  

DISPLAY F2 USING ('|');	