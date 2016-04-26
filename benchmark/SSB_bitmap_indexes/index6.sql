CREATE INDEX ttt1 on lineorder(date.d_yearmonthnum)
FROM lineorder, date
WHERE lineorder.lo_orderdatekey = date.d_datekey;
