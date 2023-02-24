// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_linux/camera_view_linux.dart';
import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraViewLinux', () {
    const kPlatformName = 'Linux';
    late CameraViewLinux cameraView;
    late List<MethodCall> log;

    setUp(() async {
      cameraView = CameraViewLinux();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(cameraView.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      CameraViewLinux.registerWith();
      expect(CameraViewPlatform.instance, isA<CameraViewLinux>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await cameraView.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
