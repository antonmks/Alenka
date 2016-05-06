# Looking for Starbucks coffee in Colorado Mountains with Alenka and CartoDB  #

Here's how to find all Starbucks locations in a Colorado State using Alenka :

First we need to get a list of all Starbucks stores from  Socrata portal in CSV format :
[https://opendata.socrata.com/api/views/xy4y-c4mk/rows.csv?accessType=DOWNLOAD](https://opendata.socrata.com/api/views/xy4y-c4mk/rows.csv?accessType=DOWNLOAD "https://opendata.socrata.com/api/views/xy4y-c4mk/rows.csv?accessType=DOWNLOAD")

There is no State column there, so we have to use latitude and longitude columns.
Lets load the data in alenka, here is a loading script  :
    
    C := LOAD 'starbucks.tbl' USING (',') AS (store_id{1}:int, name{2}:varchar(50), 
	country{13}:varchar(20), latitude{16}:decimal(3,15), longitude{17}:decimal(3,15));
    STORE C INTO 'starbucks' BINARY;

We are loading only the columns that we need.
So how do we get only Colorado stores ? Fortunately, Colorado State is very, very rectangular and is limited  by latitudes between 37 and 41 and longitudes between -102 and -109.
So here is our Alenka script to get the Colorado Starbucks locations :

    S := FILTER starbucks BY country == "US" AND latitude > 37 AND latitude < 41 AND
     longitude < -102 AND longitude > -109;
	RES := SELECT name AS name, country AS country,	 latitude AS latitude, longitude AS longitude FROM S;
    STORE RES INTO 'starbucksCOLORADO.txt' USING (',');

Lets load the results into CartoDB :

https://antonmks.cartodb.com/viz/8aea0e38-136c-11e6-8670-0e3a376473ab/public_map

You can clearly see on the map that the selected stores are indeed in Colorado !
