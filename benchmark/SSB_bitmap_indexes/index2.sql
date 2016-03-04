CREATE INDEX ttt1 on lineorder(date.d_year)
FROM lineorder, date
WHERE lineorder.lo_orderdate = date.d_datekey;