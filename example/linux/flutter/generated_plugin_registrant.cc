//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <camera_view_linux/camera_view_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) camera_view_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CameraViewPlugin");
  camera_view_plugin_register_with_registrar(camera_view_linux_registrar);
}
