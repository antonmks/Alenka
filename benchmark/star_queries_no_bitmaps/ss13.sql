BF := FILTER date BY d_weeknuminyear == 6 AND d_year == 1994;
AF := FILTER lineorder BY lo_quantity >= 26 AND lo_quantity <= 35 AND lo_discount >= 5 AND lo_discount <= 7;
AJ := SELECT lo_extendedprice AS lo_extendedprice, lo_discount AS lo_discount
      FROM AF JOIN BF on lo_orderdate = d_datekey;
D := SELECT SUM(lo_extendedprice*lo_discount) AS revenue FROM AJ;
STORE D INTO 'ss13.txt' USING ('|');