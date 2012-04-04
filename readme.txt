Alenka is a modern analytical database engine written to take advantage of vector based processing and high bandwidth of modern GPUs.
Features include:

  Vector-based processing
  CUDA programming model allows a single operation to be applied to an entire set of data at once.
  
  Self optimizing compression
  Ultra fast compression and decompression performed directly inside GPU
  
  Column-based storage 
  Minimize disk I/O by only accessing the relevant data
  
  Fast database loads
  Data load times measured in minutes, not in hours.
  
  Open source and free
  
  
Some benchmarks :  

Alenka : Pentium E5200 (2 cores), 4 GB of RAM, 1x2TB hard drive , NVidia GTX 260
Current Top #10 TPC-H 300GB non-clustered performance result : MS SQL Server 2005 : Hitachi BladeSymphony (8 CPU/8 Cores), 128 GB of RAM, 290x36GB 15K rpm drives 
Current Top #7 TPC-H 300GB non-clustered performance result : MS SQL Server 2005  : HP ProLiant DL585 G2 (4 CPU/8 Cores), 128 GB of RAM, 200x36GB 15K rpm drives

Time of Q1 of TPC-H Scale Factor 300 :

Alenka   Top#10   Top#7
  178s     485s    309s  
 
Alenka is a pretty much work in progress so please be careful if you use it on a production data :-)
 
antonmks@gmail.com  
