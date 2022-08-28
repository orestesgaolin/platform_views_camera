// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera_view_platform_interface/camera_view_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The iOS implementation of [CameraViewPlatform].
class CameraViewIOS extends CameraViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_view_ios');

  /// Registers this class as the default instance of [CameraViewPlatform]
  static void registerWith() {
    CameraViewPlatform.instance = CameraViewIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Widget getPlatformView() {
    return const _UiKitBox();
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
}

class _UiKitBox extends StatelessWidget {
  const _UiKitBox({super.key});

  @override
  Widget build(BuildContext context) {
// This is used in the platform side to register the view.
    const viewType = '@views/native-view';

    return const UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: <String, dynamic>{},
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          EagerGestureRecognizer.new,
        ),
      },
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
