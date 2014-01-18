
#include <plugin/Plugin.h>

namespace plugin {
namespace @PLUGIN_NAMESPACE@_@PLUGIN_NAME@ {

class Plugin : public plugin::Plugin
{
protected:
	plugin::Configuration Configure()
		{
		plugin::Configuration config;
		config.name = "@PLUGIN_NAMESPACE@::@PLUGIN_NAME@";
		config.description = "Caesar cipher rotating a string's characters by 13 places.";
		config.version.major = 1;
		config.version.minor = 0;
		return config;
		}
} plugin;

}
}
