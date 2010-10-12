# Requires SSL

########### next target ###############

SET(bdcat_SRCS
   bdcat.cc
)

add_executable(bdcat ${bdcat_SRCS})

target_link_libraries(bdcat)


########### install files ###############




#original Makefile.am contents follow:

### Process this file with automake to produce Makefile.in
#
#noinst_PROGRAMS = bdcat
#bdcat_SOURCES = bdcat.cc
