CREATE INDEX ttt1 on lineorder(customer.c_nation)
FROM lineorder, customer
WHERE lineorder.lo_custkey = customer.c_custkey;