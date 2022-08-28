import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.filePath});

  final String filePath;

  static Route route(String filePath) => MaterialPageRoute(
        builder: (context) => PreviewPage(
          filePath: filePath,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File: $filePath'),
      ),
      body: Center(
        child: Image.file(
          File(filePath),
        ),
      ),
    );
  }
}
