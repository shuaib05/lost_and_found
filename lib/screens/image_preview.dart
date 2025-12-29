import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.imagePath});

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Center(
        child: InteractiveViewer(child: Image.file(File(imagePath))),
      ),
    );
  }
}
