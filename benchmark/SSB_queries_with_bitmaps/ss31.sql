DF := FILTER date BY d_year == 1992 OR d_year == 1993 OR d_year == 1994 OR d_year == 1995 OR d_year == 1996 OR d_year == 1997;
SF := FILTER supplier BY s_region == "ASIA";
CF := FILTER customer BY c_region == "ASIA";

LS := SELECT lo_revenue AS lo_revenue, d_year AS d_year, s_nation AS s_nation, c_nation AS c_nation
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey
		     JOIN CF on lo_custkey = c_custkey
		     JOIN DF on lo_orderdate = d_datekey;

R := SELECT SUM(lo_revenue) AS lo_revenue1, d_year AS d_year1, c_nation AS c_nation1, s_nation AS s_nation1 FROM LS
     GROUP BY c_nation, s_nation, d_year;
	 
R1 := ORDER R BY d_year1 ASC, lo_revenue1 DESC;		 
	 
STORE R1 INTO 'ss31.txt' USING ('|');