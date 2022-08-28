import SwiftUI
import Flutter
import UIKit

@available(iOS 14.0, *)
public class SwiftCameraViewPlugin: NSObject, FlutterPlugin {
    static var controller: CameraController  = CameraController()
    
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
        case "takePicture":
            let arguments = call.arguments as! [String: Any]
            let filePath = arguments["filePath"] as! String
            SwiftCameraViewPlugin.controller.takePicture(filePath: filePath, result: result)
        case "toggle":
            SwiftCameraViewPlugin.controller.toggle()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

@available(iOS 14.0, *)
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
            binaryMessenger: messenger
        )
    }
}

@available(iOS 14.0, *)
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
        _view.backgroundColor = UIColor.gray
        let contentModel = ContentViewModel();
        let childView = UIHostingController(rootView: ContentView.init(cameraModel: contentModel))
        SwiftCameraViewPlugin.controller.setCameraModel(model: contentModel)
        childView.view.frame = frame
        _view.addConstrained(subview: childView.view)
        childView.didMove(toParent: _view.inputViewController)
    }
    
    func view() -> UIView {
        return _view
    }
}

@available(iOS 14.0, *)
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

@available(iOS 14.0, *)
class CameraController {
    private var model : ContentViewModel?
    
    func setCameraModel(model : ContentViewModel){
        self.model = model
    }
    
    func takePicture(filePath: String, result: FlutterResult){
        if (model == nil){
            result("Model has not been initialized")
            return
        }
        let frame = model!.frame
        if (frame != nil){
            do {
                try write(cgimage: frame!, to: URL.init(fileURLWithPath: filePath))
                result(filePath)
            } catch {
                result("Error: \(error)")
            }
        }else{
            result("")
        }
    }
    
    func toggle(){
        
    }
    
    func write(cgimage: CGImage, to url: URL) throws {
        let cicontext = CIContext()
        let ciimage = CIImage(cgImage: cgimage)
        try cicontext.writePNGRepresentation(of: ciimage, to: url, format: .RGBA8, colorSpace: ciimage.colorSpace!)
    }
}
