
#include "Plugin.h"

namespace plugin { namespace @PLUGIN_NAMESPACE@_@PLUGIN_NAME@ { Plugin plugin; } }

using namespace plugin::@PLUGIN_NAMESPACE@_@PLUGIN_NAME@;

plugin::Configuration Plugin::Configure()
	{
	plugin::Configuration config;
	config.name = "@PLUGIN_NAMESPACE@::@PLUGIN_NAME@";
	config.description = "<Insert description>";
	config.version.major = 0;
	config.version.minor = 1;
	return config;
	}
