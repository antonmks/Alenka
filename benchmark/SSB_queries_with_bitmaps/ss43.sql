DF := FILTER date BY d_year == 1997 OR d_year == 1998;
SF := FILTER supplier BY s_nation == "UNITED STATES";
PF := FILTER part BY p_category == "MFGR#14";
CF := FILTER customer BY c_region == "AMERICA";

LS := SELECT lo_revenue AS lo_revenue, d_year AS d_year, lo_supplycost AS lo_supplycost, s_city AS s_city, p_brand1 AS p_brand1
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey
					 JOIN CF on lo_custkey = c_custkey
					 JOIN PF on lo_partkey = p_partkey
					 JOIN DF on lo_orderdatekey = d_datekey;
					 
R := SELECT d_year AS d_year1, s_city AS s_city1,
            p_brand1 AS p_brand2, SUM(lo_revenue-lo_supplycost) AS lo_revenue1 FROM LS
     GROUP BY d_year, s_city, p_brand1;	 
 
R1 := ORDER R BY d_year1 ASC, s_city1 ASC, p_brand2 ASC;		 
	 
STORE R1 INTO 'ss43.txt' USING ('|');
