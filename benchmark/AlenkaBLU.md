Performance gains using Alenka with GPU and SSD acceleration

Alenka is an open source database developed to run fast on modern hardware.

Lets compare Alenka's performance vs IBM BLU.

IBM BLU Acceleration is a collection of technologies from the IBM Research and Development Labs for
analytical database workloads. BLU Acceleration integrates a number of different technologies including
in-memory processing of columnar data, Actionable Compression (which uses approximate Huffman encoding to
compress and pack data tightly), CPU Acceleration (which exploits SIMD technology and provides parallel vector processing), and Data Skipping.

Alenka incorporates similar technologies such as massively parallel processing of columnar data on GPU, fast compression techniques,
operations on compressed data, Data Skipping, SSD acceleration and bitmap indexing.

IBM BLU Box :

2 x Intel E5-2697 V2(24 Cores, 30 MB Cache, 2.7GHz)

8 x 32 GB 1600 MHz(PC3-12800R ECC DDR)

2 x PCIe SSD Fusion ioDrive2 Duo (2 TB; RAID 10; XFS)

2 x PCIe SSD 910 Series(1,6 TB; RAID 10; XFS)



Alenka Box

1 x Intel i3-4130 (2 cores, 3.4 GHz)

4 x 4 GB DDR3 

1 x SATA SSD OCZ Vertex3 (120 GB)

1 x SATA WD Hard Drive (2 TB)

1 x GeForce Titan GPU (6GB of DDR5 memory)

----------


SSB (Star Schema Benchmark)
Fact table 600M Rows

The Query 4.3 (a typical analytic query)

  IBM BLU :

    select d_year, s_city, p_brand1, sum(lo_revenue - lo_supplycost) as profit
    from date, customer, supplier, part, lineorder
    where lo_custkey = c_custkey
    and lo_suppkey = s_suppkey
    and lo_partkey = p_partkey
    and lo_orderdate = d_datekey
    and c_region = 'AMERICA'
    and s_nation = 'UNITED STATES'
    and (d_year = 1997 or d_year = 1998)
    and p_category = 'MFGR#14'
    group by d_year, s_city, p_brand1 order by d_year, s_city, p_brand1

Alenka : 

    DF := FILTER date BY d_year == 1997 OR d_year == 1998;
    SF := FILTER supplier BY s_nation == "UNITED STATES";
    PF := FILTER part BY p_category == "MFGR#14";
    CF := FILTER customer BY c_region == "AMERICA";
    
    LS := SELECT lo_revenue AS lo_revenue, d_year AS d_year, 
		         lo_supplycost AS lo_supplycost, s_city AS s_city, p_brand1 AS p_brand1
    FROM lineorder JOIN SF on lo_suppkey = s_suppkey
                   JOIN CF on lo_custkey = c_custkey
                   JOIN PF on lo_partkey = p_partkey
                   JOIN DF on lo_orderdate = d_datekey;
    					 
    R := SELECT d_year AS d_year1, s_city AS s_city1,
                p_brand1 AS p_brand2, SUM(lo_revenue-lo_supplycost) AS lo_revenue1 FROM LS
    GROUP BY d_year, s_city, p_brand1;	 
     
    R1 := ORDER R BY d_year1 ASC, s_city1 ASC, p_brand2 ASC;		 	 
    STORE R1 INTO 'ss43.txt' USING ('|');

*warm execution* :

IBM BLU - **1,59** sec.

Alenka - **1,17** sec.

As we can see, Alenka runs the query faster on a decidedly inferior hardware. There several Alenka features
that allow this kind of performance : 

- bitmap join indexes on dimension columns

      Filtering bitmaps is fast.Executing "AND" operation on bitmap indexes using gpu is even faster :

    `thrust::transform(dev_ptr1, dev_ptr1+mRecCount, dev_ptr2, dev_ptr1, thrust::logical_and<bool>());`

- use of SSD acceleration allowing to read only needed records from SSD drive as opposed to reading entire blocks 	and decompressing/gathering records
 
 	For example if we need to 'gather' just 25,000 records, it would be faster to read 25,000 4k blocks from SSD drive than to read entire 100,000,000 of 4 byte records segment from the same SSD drive (500 ms versus 1 second)   
 
 
- ability to operate on compressed records.

References :

Alenka : [https://github.com/antonmks/Alenka](https://github.com/antonmks/Alenka)

IBM BLU : [https://en.wikipedia.org/wiki/IBM_BLU_Acceleration](https://en.wikipedia.org/wiki/IBM_BLU_Acceleration)

IBM BLU Star Schema Benchmark : [http://www.itgain.de/news/2013/Performance_Gains_using_DB2BLU_with_Intel_Technology.pdf](http://www.itgain.de/news/2013/Performance_Gains_using_DB2BLU_with_Intel_Technology.pdf)






