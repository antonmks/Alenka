debug: CPPFLAGS = -I /usr/local/cuda/include -g -O0
release: CPPFLAGS = -I /usr/local/cuda/include -O3

debug: TARGET = debug
release: TARGET = release

debug: ../debug/libmgpuscan.a
release: ../release/libmgpuscan.a

SRC = \
	../../src/mgpusort.cpp \
	../../src/sorttables.cpp \
	../../../util/cucpp.cpp
INC = \
	../../../inc/mgpusort.h \
	../../src/sortdll.h \
	../../../util/cucpp.h \
	../../../util/util.h

../debug/libmgpuscan.a : $(SRC)
	-mkdir ../$(TARGET)
	g++ $(CPPFLAGS) -o $@ $<

