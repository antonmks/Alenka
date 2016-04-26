BF := FILTER date BY d_year == 1993;
AF := FILTER lineorder BY lo_quantity < 25 AND lo_discount >= 1 AND lo_discount <= 3;
AJ := SELECT lo_extendedprice AS lo_extendedprice, lo_discount AS lo_discount
      FROM AF JOIN BF on lo_orderdatekey = d_datekey;
D := SELECT SUM(lo_extendedprice*lo_discount) AS revenue FROM AJ;
STORE D INTO 'ss11.txt' USING ('|');
