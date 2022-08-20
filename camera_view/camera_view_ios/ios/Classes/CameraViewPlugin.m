#import "CameraViewPlugin.h"
#if __has_include(<camera_view_ios/camera_view_ios-Swift.h>)
#import <camera_view_ios/camera_view_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "camera_view_ios-Swift.h"
#endif

@implementation CameraViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCameraViewPlugin registerWithRegistrar:registrar];
}
@end
