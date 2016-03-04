B := FILTER lineitem BY discount >= 0.05 AND discount <= 0.07 AND qty < 24 AND shipdate >= 19940101 AND shipdate < 19950101;
C := SELECT SUM(price*discount) AS revenue FROM B;			
DISPLAY C  USING ('|') LIMIT 1000;