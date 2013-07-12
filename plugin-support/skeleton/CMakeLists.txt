
project(Bro-Plugin-@PLUGIN_NAMESPACE@-@PLUGIN_NAME@)

cmake_minimum_required(VERSION 2.6.3)

include(BroPlugin)

bro_plugin_begin(@PLUGIN_NAMESPACE@ @PLUGIN_NAME@)
bro_plugin_cc(src/Plugin.cc)
bro_plugin_bif(src/events.bif)
bro_plugin_bif(src/functions.bif)
bro_plugin_end()
