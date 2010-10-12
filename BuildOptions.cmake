#--------------------------------------------------------------------#
#                                                                    #
#                Bro Auxiliary tools - Build Setup                   #
#                                                                    #
#--------------------------------------------------------------------#
#
# The installation directory
set(CMAKE_INSTALL_PREFIX /usr/local
    CACHE STRING "Installation directory" FORCE)

# Uncomment to specify a custom prefix that contains the libpcap installation.
#set(PCAP_ROOT path/to/your/pcap)

# Uncomment to specify a custom directory that contains libpcap headers.
#set(PCAP_INCLUDEDIR path/to/your/pcap/include)

# Uncomment to specify a custom directory that contains the libpcap library.
#set(PCAP_LIBRARYDIR path/to/your/pcap/lib)

# Attempt to use non-blocking DNS support by default
set(USE_NB_DNS true
    CACHE BOOL "Use non-blocking DNS support" FORCE)
