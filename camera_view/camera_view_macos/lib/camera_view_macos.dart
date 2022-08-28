// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: public_member_api_docs

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The MacOS implementation of [CameraViewPlatform].
class CameraViewMacOS extends CameraViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_view_macos');

  /// Registers this class as the default instance of [CameraViewPlatform]
  static void registerWith() {
    CameraViewPlatform.instance = CameraViewMacOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getPlatformView() {
    return const NSBox();
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

class NSBox extends StatelessWidget {
  const NSBox({super.key});

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const viewType = '@views/native-view';
    // Pass parameters to the platform side.
    final creationParams = <String, dynamic>{};

    return IgnorePointer(
      child: UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
          // Factory<OneSequenceGestureRecognizer>(
          //   EagerGestureRecognizer.new,
          // ),
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
