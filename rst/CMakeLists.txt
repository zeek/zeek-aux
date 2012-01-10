set(rst_SRCS
    rst.c
)

add_executable(rst ${rst_SRCS})

target_link_libraries(rst ${BIND_LIBRARY})

AddAuxInstallTarget(rst)
