B := FILTER lineitem BY shipdate <= 19980902;
D := SELECT returnflag AS rf1, 
linestatus AS lf1,
SUM(qty) AS sum_qty,
SUM(price) AS price_sum, 
SUM((1-discount)*price) AS discount_price,
SUM((1+tax)*(1-discount)*price) AS sum_d,
AVG(qty) AS avg_qty,
AVG(price) AS avg_price,
AVG(discount) AS avg_disc,
COUNT(qty) AS count_order
FROM B	GROUP BY returnflag, linestatus;

DO := ORDER D BY rf1, lf1;

STORE DO INTO 'q1.txt' USING ('|');
