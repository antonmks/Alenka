DF := FILTER date BY d_yearmonth == "Dec1997";
CF := FILTER customer BY c_city == "UNITED KI1" OR c_city == "UNITED KI5";
SF := FILTER supplier BY s_city == "UNITED KI1" OR s_city == "UNITED KI5";

LS := SELECT lo_revenue AS lo_revenue, d_year AS d_year, s_city AS s_city, c_city AS c_city
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey
		     JOIN CF on lo_custkey = c_custkey
		     JOIN DF on lo_orderdate = d_datekey;

R := SELECT SUM(lo_revenue) AS revenue, d_year AS year, c_city AS c_city1, s_city AS s_city1 FROM LS
     GROUP BY c_city, s_city, d_year;
	 
R1 := ORDER R BY year ASC, revenue DESC;		 
	 
STORE R1 INTO 'ss34.txt' USING ('|');