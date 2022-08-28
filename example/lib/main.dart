// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:camera_view/camera_view.dart';
import 'package:example/preview/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const grey = Color.fromARGB(255, 170, 172, 178);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Platform View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cameraController = CameraController();
  String? filePath;

  @override
  Widget build(BuildContext context) {
    final linearGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        grey,
        Colors.white,
      ],
    );
    final decoration = BoxDecoration(
      gradient: linearGradient,
    );

    return Column(
      children: [
        Expanded(
          child: CameraView(),
        ),
        DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (filePath != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PreviewPage.route(filePath!));
                      },
                      child: Image.file(
                        File(filePath!),
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Icon(Icons.image),
                  ShutterButton(
                    onPressed: () async {
                      final path = await getApplicationDocumentsDirectory();
                      final file =
                          '${path.path}/image${DateTime.now().millisecondsSinceEpoch}.jpg';
                      final takenPath =
                          await cameraController.takePicture(file);
                      if (takenPath != null) {
                        setState(() {
                          filePath = takenPath;
                        });
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      cameraController.toggle();
                    },
                    icon: Icon(Icons.toggle_on),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ShutterButton extends StatefulWidget {
  const ShutterButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton> {
  var linearGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      grey,
      Colors.white,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      gradient: linearGradient,
    );

    return Listener(
      onPointerDown: (_) {
        setState(() {
          linearGradient = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              grey,
            ],
          );
        });
        setState(() {});
      },
      onPointerUp: (_) {
        linearGradient = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            grey,
            Colors.white,
          ],
        );
        setState(() {});
        widget.onPressed();
      },
      child: DecoratedBox(
        decoration: decoration.copyWith(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 8,
          ),
          child: Icon(
            Icons.camera_alt,
          ),
        ),
      ),
    );
  }
}
