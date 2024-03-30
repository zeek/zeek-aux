cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(ZeekArchiver CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

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
    "\n================================================================\n"
)
