nvcc --cubin -Xptxas=-v -arch=compute_20 -code=sm_20 -o ../cubin/search.cubin searchgen.cu
IF %ERRORLEVEL% EQU 0 cuobjdump -sass ../cubin/search.cubin > ../isa/search.isa
