
all:
	mkdir -p build && cd build && cmake .. && make

install: all
	cd build && make install

test: all
	./test.sh

.PHONY: all install test
