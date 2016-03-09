CREATE INDEX ttt1 on lineorder(part.p_category)
FROM lineorder, part
WHERE lineorder.lo_partkey = part.p_partkey;