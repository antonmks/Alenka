nvcc --cubin -arch=compute_20 -code=sm_20 -o ballotscan.cubin ballotscan.cu
IF %ERRORLEVEL% EQU 0 cuobjdump -sass ballotscan.cubin > ballotscan.isa