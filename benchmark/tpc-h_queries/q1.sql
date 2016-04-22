B := FILTER lineitem BY shipdate <= 19980902;
D := SELECT returnflag AS rf1, linestatus AS lf1, SUM(price) AS price_sum, SUM(qty) AS sum_qty,AVG(qty) AS avg_qty,
			AVG(price) AS avg_price, AVG(discount) AS avg_disc, SUM((1+tax)*(1-discount)*price) AS sum_d,
			SUM((1-discount)*price) AS discount_price, AVG(tax) AS tax_avg,
			COUNT(qty) AS qq
	 FROM B	GROUP BY returnflag, linestatus;
STORE D INTO 'mytest.txt' USING ('|');
