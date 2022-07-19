// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class CameraViewMock extends CameraViewPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CameraViewPlatformInterface', () {
    late CameraViewPlatform cameraViewPlatform;

    setUp(() {
      cameraViewPlatform = CameraViewMock();
      CameraViewPlatform.instance = cameraViewPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await CameraViewPlatform.instance.getPlatformName(),
          equals(CameraViewMock.mockPlatformName),
        );
      });
    });
  });
}
