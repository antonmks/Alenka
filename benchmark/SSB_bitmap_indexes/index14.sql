CREATE INDEX ttt1 on lineorder(date.d_yearmonth)
FROM lineorder, date
WHERE lineorder.lo_orderdate = date.d_datekey;