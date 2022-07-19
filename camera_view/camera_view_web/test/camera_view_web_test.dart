// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:camera_view_web/camera_view_web.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraViewWeb', () {
    const kPlatformName = 'Web';
    late CameraViewWeb cameraView;

    setUp(() async {
      cameraView = CameraViewWeb();
    });

    test('can be registered', () {
      CameraViewWeb.registerWith();
      expect(CameraViewPlatform.instance, isA<CameraViewWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await cameraView.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
