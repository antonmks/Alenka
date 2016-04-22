CREATE INDEX ttt1 on lineorder(supplier.s_nation)
FROM lineorder, supplier
WHERE lineorder.lo_suppkey = supplier.s_suppkey;