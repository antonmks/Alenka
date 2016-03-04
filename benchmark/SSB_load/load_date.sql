C := LOAD 'date.tbl' USING ('|') AS (d_datekey{1}:int, d_month{4}:varchar(9), d_year{5}:int, d_yearmonthnum{6}:int, d_yearmonth{7}:varchar(7), 
                                            d_weeknuminyear{12}:int);
STORE C INTO 'date' BINARY;