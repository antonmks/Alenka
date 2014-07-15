RF := FILTER region BY r_name == "ASIA";
OFI := FILTER orders BY o_orderdate >= 19940101 AND o_orderdate < 19950101;

J1 := SELECT c_nationkey AS c_nationkey, n_name AS n_name, suppkey AS suppkey, price AS price, discount AS discount
      FROM supplier
             JOIN lineitem ON s_suppkey = suppkey AND s_nationkey = c_nationkey
             JOIN OFI      ON orderkey = o_orderkey
             JOIN customer ON o_custkey = c_custkey
             JOIN nation   ON c_nationkey = n_nationkey
             JOIN RF       ON n_regionkey = r_regionkey;

F := SELECT n_name AS n_name1, SUM(price*(1-discount)) AS revenue FROM J1
      GROUP BY n_name;

F1 := ORDER F BY revenue DESC;

DISPLAY F1 USING ('|');









