# A simple SQL statement running on monster computers #

Lets see how the fastest and the most expensive machines can run a simple SQL.
Our database consists of one table lineitem with approximately 6 billion records (800 GB).

We want to filter the records based on a value of a field and then group the results by other fields:
  
    select 
    	l_returnflag,
    	l_linestatus,
    	sum(l_quantity) as sum_qty,
    	sum(l_extendedprice) as sum_base_price,
    	sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
    	sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
    	avg(l_quantity) as avg_qty,
    	avg(l_extendedprice) as avg_price,
    	avg(l_discount) as avg_disc,
    	count(*) as count_order
    from
    	lineitem
    where
    	l_shipdate <= 19980902
    group by
    	l_returnflag,
    	l_linestatus
    order by
    	l_returnflag,
    	l_linestatus
	
The computer made by Fujitsu ( **SPARC M10 with 4 SPARC64 CPU, 2TB of memory and 72 400GB SAS SSD  with Oracle 11g R2**) runs the SQL in 96 seconds. 

The server made by Hewlett-Packard ( **8 Intel Xeon E7-4870 CPU, 2TB of memory and 416 hard drives with MS SQL Server 2008**)  runs the SQL in just 47 seconds !

Cisco made server ( **4 Intel Xeon E7-4870 CPU, 1TB of memory and 10 300GB LSI WarpDrives   with Microsoft SQL Server 2008**)  runs it in 97 sconds.

IBM Power 780 Model 9179-MHB ( **8 IBM POWER7 CPU, 512 GB of memory and 52 x 69GB SAS SSD with Sybase IQ v.15.2**) finishes the SQL in only 118 seconds.

Notice that the results are not I/O limited. With the most disk subsystems the data can be read into memory in just a few seconds,
so the time is dominated by CPU calculations. The results don't come cheap though : the prices for the combined hardware and software are below :

**Fujitsu** - $**5,000,000** 

**HP** - $**408,000**

**Cisco** - $**174,000**
 
**IBM** - $**1,128,000**

The modern gpus (graphical processing units) have a massive memory bandwidth and a few teraflops of computing power. Lets see how they fare against the above servers.

Our setup : a PC with **Pentium G620 CPU, 16GB of memory, 1 Vertex3 SSD and a single Nvidia GTX Titan**. For the software we use open source gpu database alenka.
The SQL runs in just 77 seconds (disk time excluded. Why is it excluded? Because even with a cheap disk subsystem it becomes insignificant. Raid setup of 10 SSD (USD 1000) would read the compressed data in under 10 seconds).

Total price - $**1700** (the software is free and open source). 

So as you can see it is possible to compete with the big guys not just on price but on performance as well .
And these days you have to be a pretty big company to afford a license for MS SQL Server 2014 ( it costs $400,000 to run it on a box with just 4 Intel E7-4890 v2 cpus).

References :

TPC-H benchmarks : [http://www.tpc.org/tpch/results/tpch_perf_results.asp?resulttype=noncluster](http://www.tpc.org/tpch/results/tpch_perf_results.asp?resulttype=noncluster)

alenka database : [https://github.com/antonmks/Alenka](https://github.com/antonmks/Alenka)

![](http://sm1ttysm1t.com/wp-content/uploads/2014/04/COL_LOGO-100x100.jpg)








