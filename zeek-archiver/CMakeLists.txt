include(../cmake/RequireCXXStd.cmake)

add_executable(zeek-archiver)
target_sources(zeek-archiver PRIVATE zeek-archiver.cc)
target_compile_options(zeek-archiver PRIVATE -Wall -Wno-unused -Werror=vla)

install(TARGETS zeek-archiver)
