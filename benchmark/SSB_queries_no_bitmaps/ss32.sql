CF := FILTER customer BY c_nation == "UNITED STATES";
DF := FILTER date BY d_year >= 1992 AND d_year <= 1997;
SF := FILTER supplier BY s_nation == "UNITED STATES";

LS := SELECT lo_revenue AS lo_revenue, lo_orderdate AS lo_orderdate, s_city AS s_city, lo_custkey AS lo_custkey
      FROM lineorder JOIN SF on lo_suppkey = s_suppkey;

LS1 := SELECT lo_revenue AS lo_revenue, lo_orderdate AS lo_orderdate, s_city AS s_city, c_city AS c_city
       FROM LS JOIN CF on lo_custkey = c_custkey;

LS2 := SELECT lo_revenue AS lo_revenue, d_year AS d_year, s_city AS s_city, c_city AS c_city
       FROM LS1 JOIN DF on lo_orderdate = d_datekey;

R := SELECT SUM(lo_revenue) AS lo_revenue1, d_year AS d_year1, c_city AS c_city1, s_city AS s_city1 FROM LS2
     GROUP BY c_city, s_city, d_year;
	 
R1 := ORDER R BY d_year1 ASC, lo_revenue1 DESC;		 
	 
STORE R1 INTO 'ss32.txt' USING ('|');