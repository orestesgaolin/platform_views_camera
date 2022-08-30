package com.example.nativecamera

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.otaliastudios.cameraview.controls.Facing
import com.otaliastudios.cameraview.gesture.Gesture
import com.otaliastudios.cameraview.gesture.GestureAction
import io.flutter.plugin.platform.PlatformView

internal class NativeCameraView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    val cameraController: CameraController
) :
    PlatformView {
    private val TAG: String = "NativeView"

    private val cameraView: com.otaliastudios.cameraview.CameraView

    override fun getView(): View {
        return cameraView
    }

    override fun dispose() {}

    init {
        cameraView = com.otaliastudios.cameraview.CameraView(context)

        cameraView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        cameraView.keepScreenOn = true
        cameraView.open()
        cameraView.mapGesture(Gesture.PINCH, GestureAction.ZOOM); // Pinch to zoom!
        cameraView.mapGesture(Gesture.TAP, GestureAction.AUTO_FOCUS); // Tap to focus!
        cameraView.facing = Facing.FRONT
        cameraController.setView(cameraView)
    }
}