import SwiftUI
import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftCameraViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "camera_view_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftCameraViewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = FLNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "@views/native-view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformName":
      result("iOS")    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

@available(iOS 13.0, *)
class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

@available(iOS 13.0, *)
class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        _view.backgroundColor = UIColor.gray
        let childView = UIHostingController(rootView: SwiftUIView())
        childView.view.frame = frame
        _view.addConstrained(subview: childView.view)
        childView.didMove(toParent: _view.inputViewController)
    }

    func view() -> UIView {
        return _view
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
