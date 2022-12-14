// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// An implementation of [CameraViewPlatform] that uses method channels.
class MethodChannelCameraView extends CameraViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_view');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getPlatformView() {
    return const SizedBox();
  }

  @override
  Future<String?> takePicture(String path) {
    return methodChannel.invokeMethod<String>(
      'takePicture',
      {
        'filePath': path,
      },
    );
  }

  @override
  Future<void> toggle() {
    return methodChannel.invokeMethod<String>('toggle');
  }

  @override
  bool get isToggleSupported => false;
}
