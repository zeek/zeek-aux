cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

project(ZeekArchiver CXX)

if ( NOT CMAKE_BUILD_TYPE )
  set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif ()

string(TOUPPER ${CMAKE_BUILD_TYPE} BuildType)
set(extra_cxx_flags -std=c++17 -Wall -Wno-unused -Werror=vla)

add_compile_options(${extra_cxx_flags})

add_executable(zeek-archiver zeek-archiver.cc)
install(TARGETS zeek-archiver DESTINATION bin)

message(
    "\n====================|  ZeekArchiver Build Summary  |===================="
    "\n"
    "\nBuild type:        ${CMAKE_BUILD_TYPE}"
    "\nBuild dir:         ${CMAKE_BINARY_DIR}"
    "\nInstall prefix:    ${CMAKE_INSTALL_PREFIX}"
    "\n"
    "\nCXX:               ${CMAKE_CXX_COMPILER}"
    "\nCXXFLAGS (base):   ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_${BuildType}}"
    "\nCXXFLAGS (extra):  ${extra_cxx_flags}"
    "\nCPP:               ${CMAKE_CXX_COMPILER}"
    "\n================================================================\n"
)
