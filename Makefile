# Top level makefile, the real shit is at src/Makefile

default: all

.DEFAULT:
	cd src && $(MAKE) $@

install:
	cd src && $(MAKE) $@
	
all:
	cd src && $(MAKE)

cpplint_src:
	python cpplint.py --filter=-whitespace/tab,-legal/copyright,-whitespace/line_length,-readability/casting,-whitespace/comments,-runtime,-build/include, src/*

cpplint_include:
	python cpplint.py --filter=-whitespace/tab,-legal/copyright,-whitespace/line_length,-readability/casting,-whitespace/comments,-runtime,-build/include,-build/header_guard include/*

test:
	cd test && py.test -v --basetemp=tmp ssb/test_noindex.py
	cd test && py.test -v --basetemp=tmp ssb/test_bitmapindex.py 

	
.PHONY: install all cpplint_src cpplint_include test
