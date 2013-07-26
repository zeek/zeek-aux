
project(Bro-Plugin-@PLUGIN_NAMESPACE@-@PLUGIN_NAME@)

cmake_minimum_required(VERSION 2.6.3)

if ( NOT BRO_DIST )
    message(FATAL_ERROR "BRO_DIST not set")
endif ()

set(CMAKE_MODULE_PATH ${BRO_DIST}/cmake)

include(BroPlugin)

bro_plugin_begin(@PLUGIN_NAMESPACE@ @PLUGIN_NAME@)
bro_plugin_cc(src/Plugin.cc)
bro_plugin_bif(src/consts.bif)
bro_plugin_bif(src/events.bif)
bro_plugin_bif(src/functions.bif)
bro_plugin_end()
