CREATE INDEX ttt1 on lineorder(supplier.s_city)
FROM lineorder, supplier
WHERE lineorder.lo_suppkey = supplier.s_suppkey;