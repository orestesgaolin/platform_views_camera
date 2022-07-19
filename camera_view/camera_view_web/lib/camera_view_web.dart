// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';

/// The Web implementation of [CameraViewPlatform].
class CameraViewWeb extends CameraViewPlatform {
  /// Registers this class as the default instance of [CameraViewPlatform]
  static void registerWith([Object? registrar]) {
    CameraViewPlatform.instance = CameraViewWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
