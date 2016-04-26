CREATE INDEX ttt1 on lineorder(date.d_weeknuminyear)
FROM lineorder, date
WHERE lineorder.lo_orderdatekey = date.d_datekey;
