// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view/camera_view.dart';
import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraViewPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements CameraViewPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraView', () {
    late CameraViewPlatform cameraViewPlatform;

    setUp(() {
      cameraViewPlatform = MockCameraViewPlatform();
      CameraViewPlatform.instance = cameraViewPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => cameraViewPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => cameraViewPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
