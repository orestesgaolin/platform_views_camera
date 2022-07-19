import FlutterMacOS
import Foundation

public class CameraViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "camera_view_macos",
      binaryMessenger: registrar.messenger)
    let instance = CameraViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformName":
      result("MacOS")    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
