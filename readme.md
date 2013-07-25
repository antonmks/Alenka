## Welcome to Alenka - GPU database engine

### How to build?

Download [Alenka](https://github.com/antonmks/Alenka/archive/master.zip)

Download [CUDPP](http://code.google.com/p/cudpp) library 

Download [ModernGpu](https://github.com/NVlabs/moderngpu) library

Install CUDPP and ModernGPU into Alenka directory

Run Makefile or Makefile.win


### What is this?

This is a GPU based database engine written to use vector based processing and high bandwidth of modern GPUs

### Features :

  *  Vector-based processing  
    CUDA programming model allows a single operation to be applied to an entire set of data at once.
	
  * Smart compression  
    Ultra fast compression and decompression performed directly inside GPU.
	
  * Column-based storage  
    Minimize disk I/O by only accessing the relevant data.

  * Data skipping  
    Better performance without indexes.	

### How to use it ?

Create your data files :

Run scripts load_orders.sql, load_lineitem.sql and load_customer.sql to create your database files.


##### Step 1 - Load the data files 

`O := LOAD 'orders' BINARY AS (o_orderkey{1}:int, o_custkey{2}:int, o_orderdate{5}:int, o_shippriority{8}:int);`

` C := LOAD 'customer' BINARY AS (c_custkey{1}:int, c_mktsegment{7}:varchar(10));`

` L := LOAD 'lineitem' BINARY AS (l_orderkey{1}:int,  price{6}:decimal, discount{7}:decimal, shipdate{11}:int);`

##### Step 2 - Filter data

` OFI := FILTER O BY o_orderdate < 19950315;`

` CF := FILTER C BY c_mktsegment == "BUILDING";`

` LF := FILTER L BY shipdate > 19950315;`

##### Step 3 - Join data

` OLC := SELECT o_orderkey AS o_orderkey, o_orderdate AS o_orderdate,`
` o_shippriority AS o_shippriority, price AS price, discount AS discount`
` FROM LF JOIN OFI ON l_orderkey = o_orderkey `
` JOIN CF ON o_custkey = c_custkey;`

##### Step 4 - Group data


` F := SELECT o_orderkey AS o_orderkey1, o_orderdate AS orderdate1, `
`o_shippriority AS priority,  SUM(price*(1-discount)) AS sum_revenue,
 COUNT(o_orderkey) AS cnt`  
`FROM OLC GROUP BY o_orderkey, o_orderdate, o_shippriority;`	


##### Step 5 - Order data


`RES := ORDER F BY sum_revenue DESC, orderdate1 ASC;`


##### Step 6 - Save the results 


`STORE RES INTO 'results.txt' USING ('|') LIMIT 10;`

### How fast is it?

Using TPC-H benchmark at the scale 1000 (1TB of data) we compared the following systems :

My system (Total cost : 1,700 USD) : 

- CPU - Pentium G620, 2 cores
- GPU - NVidia GTX Titan, 6GB of DDR5 GPU memory
- 16GB of memory
- 1 Vertex3 120GB SSD 
- AlenkaDB 
                

Top #7 TPC-H result at scale 1000 (Total cost : $1,128,288 USD):

- IBM Power 780 Model 9179-MHB 
- 8 IBM POWER7 4.1GHz CPUs, 32 cores
- 512 GB of memory
- 52 x 69GB SAS SSD
- Sybase IQ Single Application Server Edition v.15.2



<table>
  <tr>
    <th></th><th>Q1</th><th>Q3</th><th>Q6</th>
  </tr>
  <tr>
    <td>IBM+Sybase</td><td>118</td><td>27</td><td>2.5</td>
  </tr>
  <tr>
    <td>Titan+Alenka</td><td>72</td><td>23</td><td>4.0</td>
  </tr>
</table>

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/924b3b89c15fc603702a40b6ef0a718f "githalytics.com")](http://githalytics.com/antonmks/Alenka)

---

