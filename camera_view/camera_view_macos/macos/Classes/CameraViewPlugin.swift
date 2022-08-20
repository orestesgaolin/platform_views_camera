import SwiftUI
import Cocoa
import FlutterMacOS
import Foundation

@available(macOS 11.00, *)
public class CameraViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "camera_view_macos",
      binaryMessenger: registrar.messenger)
    let instance = CameraViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = FLNativeViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "@views/native-view")
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


@available(macOS 11.00, *)
class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        return NSHostingView(rootView: CameraView())
    }
}

@available(macOS 11.00, *)
class FLNativeView: NSView {
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init(frame: frame)
        super.wantsLayer = true
        super.addSubview(NSHostingView(rootView: CameraView()))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.wantsLayer = true
        super.addSubview(NSHostingView(rootView: CameraView()))
    }
}

