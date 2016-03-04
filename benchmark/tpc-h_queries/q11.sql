NF := FILTER nation BY n_name == "GERMANY";

SN := SELECT s_suppkey AS s_suppkey
      FROM supplier JOIN NF ON s_nationkey = n_nationkey;
	  
PN := SELECT ps_supplycost AS ps_supplycost, ps_availqty AS ps_availqty, ps_partkey AS ps_partkey
	  FROM partsupp JOIN SN ON ps_suppkey = s_suppkey;
	  
PP := SELECT SUM(ps_availqty*ps_supplycost)*0.00002 AS amount FROM PN;

PG := SELECT ps_partkey AS ps_partkey1, SUM(ps_supplycost * ps_availqty) AS value
	  FROM PN
	  GROUP BY ps_partkey;	  
	  
  
RES := FILTER PG BY value > PP.amount;

R := ORDER RES BY value DESC;

STORE R INTO 'mytest.txt' USING ('|');  