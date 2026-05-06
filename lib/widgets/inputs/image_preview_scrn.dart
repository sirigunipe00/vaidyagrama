import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {

  const ImagePreviewScreen({
    super.key,
    required this.imageFile,
    required this.onDone,
    required this.onRecapture,
  });
  final File imageFile;
  final VoidCallback onDone;
  final VoidCallback onRecapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Image')),
      body: Column(
        children: [
          Expanded(
            child: Image.file(imageFile, fit: BoxFit.contain),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onRecapture,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Retake'),
              ),
              ElevatedButton.icon(
                onPressed: onDone,
                icon: const Icon(Icons.check),
                label: const Text('Done'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
