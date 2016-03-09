PF := FILTER part BY (p_brand1 == "MFGR#2221") OR (p_brand1 == "MFGR#2222") OR (p_brand1 == "MFGR#2223") OR
                  (p_brand1 == "MFGR#2224") OR (p_brand1 == "MFGR#2225") OR (p_brand1 == "MFGR#2226") OR
				  (p_brand1 == "MFGR#2227") OR (p_brand1 == "MFGR#2228");
SF := FILTER supplier BY s_region == "ASIA";

LS := SELECT lo_revenue AS lo_revenue, p_brand1 AS p_brand1, d_year AS d_year
      FROM lineorder JOIN PF on lo_partkey = p_partkey
		     JOIN SF on lo_suppkey = s_suppkey
		     JOIN date on lo_orderdate = d_datekey;

R := SELECT SUM(lo_revenue) AS lo_revenue, d_year AS d_year1, p_brand1 AS p_brand FROM LS
     GROUP BY d_year, p_brand1;
	 
R1 := ORDER R BY d_year1, p_brand;	
	 
STORE R1 INTO 'ss22.txt' USING ('|');