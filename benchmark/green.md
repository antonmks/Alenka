Processing 6 billion records in 4 seconds on a home PC.

Lately I see a lot of hype around Hadoop. However if you look close at the performance of Hadoop
clusters it is not all that stellar. Actually it is more like a terrible waste of computing cycles.
Let's see if we can find a greener, more environmentally friendly solution to a problem of big data.

Our first ingredient is NVidia Titan GPU : it is a relatively cheap, massively parallel GPU.

Second ingredient would be an open source column based database that lets us to store and process each column separately using GPU :
[https://github.com/antonmks/Alenka](https://github.com/antonmks/Alenka)

The third and the last ingredient would be a smart way to sort our data in order to minimize the processing.

The GPU memory is a limited resource. Even high-end GPUs have at most 8GB of memory, which means that our data needs to be
split and processed in pieces that can fit a GPU memory. In Alenka we can specify the size of these pieces when we create a database.

TPC-H queries is a good way to measure the performance : lets implement a few of queries and compare the results to those obtained on a Hadoop cluster.

The largest table in our test is lineitem - at scale 1000 it contains 6 billion records.
Query 6 looks like this :
 
    select
    	sum(l_extendedprice * l_discount) as revenue    
    from lineitem
    where
       	l_discount >= 0.05 AND l_discount <= 0.07 AND l_qty < 24 
        AND l_shipdate >= 19940101 AND l_shipdate < 19950101;
     
	
To quickly select matching pieces(segments) from our database we need to presort the file on l_shipdate field before creating a database. Alenka stores min and max values of each segment - because of this it can quickly discard the segments that do not match out filter conditions. The segments that do match we pass to a GPU to calculate the revenue.
The entire operation takes about 4 seconds.

Now lets look at query 1 :

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
    	l_shipdate <=  19980902
    group by
    	l_returnflag,
    	l_linestatus
    order by
    	l_returnflag,
    	l_linestatus;
    
The filter condition lets us discard only a small part of segments so the majority of the data has to be sent to GPU. After data is filtered, it needs to be aggregated, which is not a problem for our 4.5 teraflops GPU. All operations take 72 seconds.

Query 3 is a bit different - it involves joining a few tables :

    select
    	l_orderkey,
    	sum(l_extendedprice * (1 - l_discount)) as revenue,
    	o_orderdate,
    	o_shippriority
    from
    	customer,
    	orders,
    	lineitem
    where
    	c_mktsegment = "BUILDING"
    	and c_custkey = o_custkey
    	and l_orderkey = o_orderkey
    	and o_orderdate < 19950315
    	and l_shipdate > 19950315
    group by
    	l_orderkey,
    	o_orderdate,
    	o_shippriority
    order by
    	revenue desc,
    	o_orderdate;
	
We can filter the segments very fast if lineitem table is presorted on l_shipdate and orders table is presorted on o_orderdate field. Remember that segments store min/max values!

Additionally, when creating a database we can specify the sort order of every segment of lineitem table on l_orderkey - this way we can quickly join tables lineitem and orders using sort/merge join algorithm (which requires joined tables to be sorted on a join key). 
After that we perform a grouping operation and sort the results. The entire operation takes 23 seconds.

Notice that results were obtained on a PC with following specs :

Pentium G620(2 cores), 1 Vertex3 SSD 120GB drive, 1 2TB WD HD, 16GB of main memory and NVidia Titan(6GB) card.

Now lets compare these results with [publicly available](http://pages.cs.wisc.edu/~jignesh/publ/underattack.pdf) Hadoop Hive TPC-H results :

Hive queries were run on a 16 node cluster . Each node has dual Intel Xeon L5630 quad core CPU,32 GB of main memory, and 10 SAS 10K RPM 300GB hard drives.

<table>
  <tr>
    <th></th><th>Q1</th><th>Q3</th><th>Q6</th>
  </tr>
  <tr>
    <td>Hadoop</td><td>443</td><td>1125</td><td>166</td>
  </tr>
  <tr>
    <td>Titan*</td><td>72</td><td>23</td><td>4</td>
  </tr>
</table>

 \* - time is counted as total processing time minus disk time.

As we can see a single low end PC with a GPU is perfectly capable of outperforming a Hadoop cluster.

P.S.
Alenka is still work in progress, but if you have a project with lots of data - let me know, I might be able to help you.

antonmks@gmail.com 



