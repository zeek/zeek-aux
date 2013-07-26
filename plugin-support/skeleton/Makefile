
CMAKE_BUILD_DIR=dylib

all: build

check:
	@test -n "$$BRO" || (echo 'BRO not set; use "make BRO=<path-to-bro-source-tree>"'; exit 1)
	@test -e $$BRO/bro-path-dev.in || (echo "$$BRO is not a Bro source tree"; exit 1)
	@test -e $$BRO/build/bro-path-dev || (echo "$$BRO/build is not a Bro build tree; did you build Bro?"; exit 1)

configure: check
	@mkdir -p $(CMAKE_BUILD_DIR)
	( cd $(CMAKE_BUILD_DIR) && cmake -DBRO_DIST=$$BRO .. )

build:
	@test -e $(CMAKE_BUILD_DIR) || make configure
	( cd $(CMAKE_BUILD_DIR) && make )

clean:
	( cd $(CMAKE_BUILD_DIR) && make clean )

distclean:
	rm -rf $(CMAKE_BUILD_DIR)
