
#ifndef BRO_PLUGIN_@PLUGIN_NAMESPACE_UPPER@_@PLUGIN_NAME_UPPER@
#define BRO_PLUGIN_@PLUGIN_NAMESPACE_UPPER@_@PLUGIN_NAME_UPPER@

#include <plugin/Plugin.h>

namespace plugin {
namespace @PLUGIN_NAMESPACE@_@PLUGIN_NAME@ {

class Plugin : public ::plugin::Plugin
{
protected:
	// Overridden from plugin::Plugin.
	plugin::Configuration Configure() override;
};

extern Plugin plugin;

}
}

#endif
