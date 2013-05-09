A := LOAD 'lineitem' BINARY AS (l_qty{5}:int, l_price{6}:decimal, l_discount{7}:decimal, l_shipdate{11}:int);
B := FILTER A BY l_discount >= 0.05 AND l_discount <= 0.07 AND l_qty < 24 AND l_shipdate >= 19940101 AND l_shipdate < 19950101;
C := SELECT SUM(l_price*l_discount) AS revenue FROM B;			
STORE C INTO 'mytest.txt' USING ('|') LIMIT 1000;