
Copyright (c) 2011, Sean Baxter (lightborn@gmail.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Modern GPU nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Sean Baxter BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Modern GPU library code for CUDA
(C) 2011 Sean Baxter (email sean at moderngpu)
http://www.moderngpu.com/

Code licensed under BSD.

64bit CUDA builds are considered experimental and not yet tested. To avoid 
spills, the register counts were increased, which lowers SM occupancy. It is
likely that the 64bit builds can be optimized to run at the same occupancy as
32bit builds, but this has not been done yet.

Additionally, GNU makefile support is spotty at this point.

Directories:

inc - header files for top-level libraries.

scan - development branch for new MGPU Scan library. Don't use this if you're following the tutorial.

snippets - fragments of code presented in the tutorial, here in .cu and .cpp files for convenience.

sort - MGPU Sort library. Functional. use the inc/mgpusort.h interface.

sparse - development branch for the MGPU Sparse library.

support - small projects from the Introduction section of the tutorial. This includes the globalscan example. inc/mgpuscan.h is currently implemented by support/src/mgpuscan.

util - cucpp wrapper for CUDA driver API.
