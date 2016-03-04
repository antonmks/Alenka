DF := FILTER date BY d_year == 1997 OR d_year == 1998;
SF := FILTER supplier BY s_nation == "UNITED STATES";
PF := FILTER part BY p_category == "MFGR#14";
CF := FILTER customer BY c_region == "AMERICA";

LS := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost, lo_custkey AS lo_custkey, 
	     lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate, s_city AS s_city 
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey;

LS1 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost,
	      lo_partkey AS lo_partkey, lo_orderdate AS lo_orderdate, s_city AS s_city
       FROM LS JOIN CF on lo_custkey = c_custkey;

LS2 := SELECT lo_revenue AS lo_revenue, lo_supplycost AS lo_supplycost,
	      lo_orderdate AS lo_orderdate, p_brand1 AS p_brand, s_city AS s_city
      FROM LS1 JOIN PF on lo_partkey = p_partkey;

LS3 := SELECT lo_revenue AS lo_revenue, d_year AS d_year, lo_supplycost AS lo_supplycost, s_city AS s_city,
	      p_brand AS p_brand
       FROM LS2 JOIN DF on lo_orderdate = d_datekey;

R := SELECT d_year AS d_year1, s_city AS s_city1,
            p_brand AS p_brand1, SUM(lo_revenue-lo_supplycost) AS lo_revenue1 FROM LS3
     GROUP BY d_year, s_city, p_brand;	 
 
R1 := ORDER R BY d_year1 ASC, s_city1 ASC, p_brand1 ASC;		 
	 
STORE R1 INTO 'ss43.txt' USING ('|');