
CMAKE_BUILD_DIR=dylib
CMAKE_PRE_CACHE=../CMakeCachePreload.txt

# @test -e $(CMAKE_BUILD_DIR) || ( echo "Build directory already exists; do 'make clean' first if you want to re-init" )

all: build

configure:
	@mkdir -p $(CMAKE_BUILD_DIR)
	( cd $(CMAKE_BUILD_DIR) && cmake -C $(CMAKE_PRE_CACHE) .. )

build:
	@test -e $(CMAKE_BUILD_DIR) || make configure
	( cd $(CMAKE_BUILD_DIR) && make )

clean:
	( cd $(CMAKE_BUILD_DIR) && make clean )

distclean:
	rm -rf $(CMAKE_BUILD_DIR)


