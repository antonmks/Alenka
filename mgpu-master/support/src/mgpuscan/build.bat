nvcc -arch=compute_20 -code=sm_20 -Xptxas=-v --cubin -o globalscan.cubin globalscan.cu
IF %ERRORLEVEL% EQU 0 cuobjdump -sass globalscan.cubin > globalscan.isa
