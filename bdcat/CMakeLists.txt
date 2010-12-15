set(bdcat_SRCS
    bdcat.cc
)

add_executable(bdcat ${bdcat_SRCS})

target_link_libraries(bdcat ${OpenSSL_LIBRARIES})

install(TARGETS bdcat DESTINATION bin)
