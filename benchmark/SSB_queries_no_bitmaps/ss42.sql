DF := FILTER date BY d_year == 1997 OR d_year == 1998;
SF := FILTER supplier BY s_region == "AMERICA";
PF := FILTER part BY p_mfgr == "MFGR#1" OR p_mfgr == "MFGR#2";
CF := FILTER customer BY c_region == "AMERICA";

LS := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost, lo_custkey AS lo_custkey, 
	     lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate, s_nation AS s_nation
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey;

LS1 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost,
	      lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate, s_nation AS s_nation
       FROM LS JOIN CF on lo_custkey = c_custkey;

LS2 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost,
	      lo_orderdate AS lo_orderdate, p_category AS p_category, s_nation AS s_nation
      FROM LS1 JOIN PF on lo_partkey = p_partkey;

LS3 := SELECT lo_revenue AS lo_revenue, d_year AS d_year, lo_supplycost AS lo_supplycost, s_nation AS s_nation,
	      p_category AS p_category
       FROM LS2 JOIN DF on lo_orderdatekey = d_datekey;

R := SELECT d_year AS d_year1, s_nation AS s_nation1, p_category AS p_category1,
            SUM(lo_revenue-lo_supplycost) AS lo_revenue1  FROM LS3
     GROUP BY d_year, s_nation, p_category;

	 
R1 := ORDER R BY d_year1, s_nation1, p_category1;		 
	 
STORE R1 INTO 'ss42.txt' USING ('|');
