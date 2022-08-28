package com.example.verygoodcore

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import androidx.lifecycle.LifecycleOwner
import com.otaliastudios.cameraview.CameraListener
import com.otaliastudios.cameraview.FileCallback
import com.otaliastudios.cameraview.PictureResult
import com.otaliastudios.cameraview.controls.Facing
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File


class CameraViewPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var TAG: String = "CameraViewPlugin"

    private var context: Context? = null
    private var controller: CameraController = CameraController()
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformName") {
            result.success("Android")
        } else if (call.method == "toggle") {
            controller.toggle()
            result.success("")
        } else if (call.method == "takePicture") {
            val filePath = call.argument<String>("filePath")
            if (filePath != null) {
                controller.takePicture(filePath, result)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "Attached to activity")
        val owner = binding.activity as LifecycleOwner
        Log.d(TAG, "Owner is $owner")

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "camera_view_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("@views/native-view", NativeViewFactory(controller))

        controller.attachedToActivity(owner)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "Detached to activity")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(TAG, "Attached to activity")
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "Detached to activity")
    }
}

class NativeViewFactory(val cameraController: CameraController) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeCameraView(context, viewId, creationParams, cameraController)
    }
}

class CameraController : CameraListener() {
    private lateinit var view: com.otaliastudios.cameraview.CameraView
    private val TAG: String = "CameraController"
    private var takePictureFile: File? = null
    private var takePictureResult: MethodChannel.Result? = null

    fun setView(view: com.otaliastudios.cameraview.CameraView) {
        this.view = view
        view.addCameraListener(this)
    }

    override fun onPictureTaken(result: PictureResult) {
        if (takePictureFile == null) {
            throw Exception("File needs to be provided")
        }

        val callback = FileCallback { file ->
            if (file == null) {
                takePictureResult!!.error("-1", "File has not been created", "")
            } else {
                takePictureResult!!.success(file.path)
                Log.d(TAG, "Picture saved: ${file.path}")
                takePictureFile = null
                takePictureResult = null
            }
        }

        result.toFile(takePictureFile!!, callback)
        Log.d(TAG, "Picture taken: ${result}")
    }

    fun toggle() {
        if (view.facing == Facing.FRONT) {
            view.facing = Facing.BACK
        } else {
            view.facing = Facing.FRONT
        }
    }

    fun takePicture(filePath: String, result: Result) {
        if (takePictureFile != null) {
            throw Exception("Cannot call until the last takePicture has finished")
        }
        takePictureResult = result
        takePictureFile = File(filePath)
        view.takePicture()
    }

    fun attachedToActivity(owner: LifecycleOwner) {
        view.setLifecycleOwner(owner)
    }
}