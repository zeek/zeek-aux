#--------------------------------------------------------------------#
#                                                                    #
#                Bro Auxiliary tools - Build Setup                   #
#                                                                    #
#--------------------------------------------------------------------#
#
# The installation directory
set(CMAKE_INSTALL_PREFIX /usr/local
    CACHE STRING "Installation directory" FORCE)

set(ENABLE_DEBUG false
    CACHE STRING "Compile with debugging symbols" FORCE)

set(ENABLE_RELEASE false
    CACHE STRING "Use -O3 compiler optimizations" FORCE)

##
## Configure Dependencies for Non-Standard Paths
##

# Uncomment to specify a custom prefix that contains the libpcap installation.
#set(PCAP_ROOT_DIR path/to/your/pcap)

# Uncomment to specify a custom prefix containing the BIND installation.
#set(BIND_ROOT_DIR path/to/your/bind)
