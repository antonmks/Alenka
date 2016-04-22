C := LOAD 'date.tbl' USING ('|') AS (
	d_datekey{1}:int, 
	d_date{2}:varchar(18),
	d_dayofweek{3}:varchar(9),
	d_month{4}:varchar(9), 
	d_year{5}:int, 
	d_yearmonthnum{6}:int, 
	d_yearmonth{7}:varchar(7),
	d_daynuminweek{8}:int,
	d_daynuminmonth{9}:int,
	d_daynuminyear{10}:int,
	d_monthnuminyear{11}:int,
	d_weeknuminyear{12}:int,
	d_sellingseason{13}:varchar(12),
	d_lastdayinweekfk{14}:int,
	d_lastdayinmonthfl{15}:int,
	d_holidayfl{16}:int,
	d_weekdayfl{17}:int
);
STORE C INTO 'date' BINARY;