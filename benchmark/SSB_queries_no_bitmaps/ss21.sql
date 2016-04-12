PF := FILTER part BY p_category == "MFGR#12";
SF := FILTER supplier BY s_region == "AMERICA";

LS := SELECT lo_revenue AS lo_revenue, lo_orderdate AS lo_orderdate, lo_suppkey AS lo_suppkey, p_brand1 AS p_brand1
      FROM lineorder JOIN PF on lo_partkey = p_partkey;

LP := SELECT lo_revenue AS lo_revenue, p_brand1 AS p_brand1, lo_orderdate AS lo_orderdate
      FROM LS JOIN SF on lo_suppkey = s_suppkey;

LD := SELECT lo_revenue AS lo_revenue,  p_brand1 AS p_brand1, d_year AS d_year
      FROM LP JOIN date on lo_orderdate = d_datekey; 

R := SELECT SUM(lo_revenue) AS lo_revenue1, d_year AS d_year1, p_brand1 AS p_brand FROM LD
     GROUP BY d_year, p_brand1;
	 
R1 := ORDER R BY d_year1, p_brand;	 
	 
STORE R1 INTO 'ss21.txt' USING ('|');