A := LOAD 'lineitem' BINARY AS (qty{5}:int, price{6}:decimal, discount{7}:decimal, tax{8}:decimal, rf{9}:varchar(1), lf{10}:varchar(1), shipdate{11}:int);
B := FILTER A BY shipdate <= 19980902;
D := SELECT rf AS rf1, lf AS lf1, SUM(price) AS price_sum, SUM(qty) AS sum_qty,AVG(qty) AS avg_qty, AVG(price) AS avg_price, AVG(discount) AS avg_disc,
            SUM((1+tax)*(1-discount)*price) AS sum_d, SUM((1-discount)*price) AS discount_price, AVG(tax) AS tax_avg,
             COUNT(qty) AS qq
	 FROM B	GROUP BY rf, lf;
STORE D INTO 'mytest.txt' USING ('|');