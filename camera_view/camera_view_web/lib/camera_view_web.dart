// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/widgets.dart';

/// The Web implementation of [CameraViewPlatform].
class CameraViewWeb extends CameraViewPlatform {
  /// Registers this class as the default instance of [CameraViewPlatform]
  static void registerWith([Object? registrar]) {
    CameraViewPlatform.instance = CameraViewWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';

  @override
  Widget getPlatformView() {
    throw UnimplementedError();
  }

  @override
  bool get isToggleSupported => throw UnimplementedError();

  @override
  Future<String?> takePicture(String path) {
    throw UnimplementedError();
  }

  @override
  Future<void> toggle() {
    throw UnimplementedError();
  }
}
