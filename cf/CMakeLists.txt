set(cf_SRCS
    cf.c
    version.c
)

add_executable(cf ${cf_SRCS})

target_link_libraries(cf)

install(TARGETS cf DESTINATION bin)
