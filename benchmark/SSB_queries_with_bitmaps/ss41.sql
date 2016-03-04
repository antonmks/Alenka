SF := FILTER supplier BY s_region == "AMERICA";
CF := FILTER customer BY c_region == "AMERICA";
PF := FILTER part BY p_mfgr == "MFGR#1" OR p_mfgr == "MFGR#2";

LS := SELECT lo_revenue AS lo_revenue, d_year AS d_year, lo_supplycost AS lo_supplycost, c_nation AS c_nation	      
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey
		     JOIN CF on lo_custkey = c_custkey
		     JOIN PF on lo_partkey = p_partkey	
		     JOIN date on lo_orderdate = d_datekey;

R := SELECT SUM(lo_revenue - lo_supplycost) AS lo_profit, d_year AS d_year1, c_nation AS c_nation1  FROM LS
     GROUP BY d_year, c_nation;
	 
R1 := ORDER R BY d_year1, c_nation1;		 
	 
STORE R1 INTO 'ss41.txt' USING ('|');