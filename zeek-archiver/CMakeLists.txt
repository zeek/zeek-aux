add_executable(zeek-archiver zeek-archiver.cc)

set_target_properties(zeek-archiver PROPERTIES COMPILE_FLAGS
    "-std=c++17 -Wall -Wno-unused -Werror=vla")

AddAuxInstallTarget(zeek-archiver)
