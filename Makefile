# Top level makefile, the real shit is at src/Makefile

default: all

.DEFAULT:
	cd src && $(MAKE) $@

install:
	cd src && $(MAKE) $@
	
all:
	cd src && $(MAKE)

cpplint:
	python cpplint.py --filter=-whitespace/tab,-legal/copyright,-whitespace/line_length,-readability/casting,-whitespace/comments src/*
	python cpplint.py --filter=-whitespace/tab,-legal/copyright,-whitespace/line_length,-readability/casting,-whitespace/comments include/*	
	
.PHONY: install all cpplint	