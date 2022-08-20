// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_macos/camera_view_macos.dart';
import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraViewMacOS', () {
    const kPlatformName = 'MacOS';
    late CameraViewMacOS cameraView;
    late List<MethodCall> log;

    setUp(() async {
      cameraView = CameraViewMacOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
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
      CameraViewMacOS.registerWith();
      expect(CameraViewPlatform.instance, isA<CameraViewMacOS>());
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
