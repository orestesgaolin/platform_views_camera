// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/src/method_channel_camera_view.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of camera_view must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `CameraView`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [CameraViewPlatform] methods.
abstract class CameraViewPlatform extends PlatformInterface {
  /// Constructs a CameraViewPlatform.
  CameraViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraViewPlatform _instance = MethodChannelCameraView();

  /// The default instance of [CameraViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraView].
  static CameraViewPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CameraViewPlatform] when they register themselves.
  static set instance(CameraViewPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// Returns the platform specific widget
  Widget getPlatformView();

  /// Whether toggling of the camera is supported
  bool get isToggleSupported;

  /// Toggles the camera view between front and back camera
  Future<void> toggle();

  /// Takes picture with the current camera
  Future<String?> takePicture(String path);
}

class CameraController {
  final CameraViewPlatform _platform = CameraViewPlatform.instance;

  Future<void> toggle() async {
    await _platform.toggle();
  }

  Future<String?> takePicture(String path) async {
    return _platform.takePicture(path);
  }
}
