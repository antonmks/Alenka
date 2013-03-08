nvcc --cubin -Xptxas=-v -arch=compute_20 -code=sm_20 -o segscan.cubin segscan.cu
IF %ERRORLEVEL% EQU 0 cuobjdump -sass segscan.cubin > segscan.isa
