import SwiftUI
import Cocoa
import FlutterMacOS
import Foundation

@available(macOS 11.00, *)
public class CameraViewPlugin: NSObject, FlutterPlugin {
    static var controller: CameraController  = CameraController()
    
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
            result("macOS")
        case "takePicture":
            let arguments = call.arguments as! [String: Any]
            let filePath = arguments["filePath"] as! String
            CameraViewPlugin.controller.takePicture(filePath: filePath, result: result)
        case "toggle":
            CameraViewPlugin.controller.toggle()
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
        let contentModel = ContentViewModel();
        let childView = ContentView.init(cameraModel: contentModel)
        CameraViewPlugin.controller.setCameraModel(model: contentModel)
        return NSHostingView(rootView: childView)
    }
}


@available(macOS 11.0, *)
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
