SF := FILTER supplier BY s_region == "AMERICA";
CF := FILTER customer BY c_region == "AMERICA";
PF := FILTER part BY p_mfgr == "MFGR#1" OR p_mfgr == "MFGR#2";

LS := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost, lo_custkey AS lo_custkey, 
	     lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey;

LS1 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost, c_nation AS c_nation,
	      lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate
       FROM LS JOIN CF on lo_custkey = c_custkey;

LS2 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost, c_nation AS c_nation,
	      lo_orderdate AS lo_orderdate
      FROM LS1 JOIN PF on lo_partkey = p_partkey;

LS3 := SELECT lo_revenue AS lo_revenue, d_year AS d_year, lo_supplycost AS lo_supplycost, c_nation AS c_nation	      
       FROM LS2 JOIN date on lo_orderdatekey = d_datekey;

R := SELECT SUM(lo_revenue - lo_supplycost) AS lo_profit, d_year AS d_year1, c_nation AS c_nation1  FROM LS3
     GROUP BY d_year, c_nation;
	 
R1 := ORDER R BY d_year1, c_nation1;		 
	 
STORE R1 INTO 'ss41.txt' USING ('|');
