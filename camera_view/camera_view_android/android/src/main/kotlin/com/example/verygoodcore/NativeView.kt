package com.example.verygoodcore

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.otaliastudios.cameraview.controls.Facing
import com.otaliastudios.cameraview.gesture.Gesture
import com.otaliastudios.cameraview.gesture.GestureAction
import io.flutter.plugin.platform.PlatformView

internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val TAG: String = "NativeView"

    private val cameraView: com.otaliastudios.cameraview.CameraView

    override fun getView(): View {
        return cameraView
    }

    override fun dispose() {}

    init {
        cameraView = com.otaliastudios.cameraview.CameraView(context)
        cameraView.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT)
        cameraView.keepScreenOn = true
        cameraView.open()
        cameraView.mapGesture(Gesture.PINCH, GestureAction.ZOOM); // Pinch to zoom!
        cameraView.mapGesture(Gesture.TAP, GestureAction.AUTO_FOCUS); // Tap to focus!
        cameraView.mapGesture(Gesture.LONG_TAP, GestureAction.TAKE_PICTURE);
        cameraView.facing = Facing.FRONT
//        view.setLifecycleOwner(context as LifecycleOwner)
    }

//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        activity = binding.activity
//        Log.d(TAG, "Activity attached")
//        view.open()
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        activity = null
//        view.close()
//        Log.d(TAG, "Activity detached for config changes")
//    }
//
//    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//        activity = binding.activity
//        view.open()
//        Log.d(TAG, "Activity reattached")
//    }
//
//    override fun onDetachedFromActivity() {
//        activity = null
//        view.destroy();
//        Log.d(TAG, "Activity detached")
//    }
}