import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageBoundingBoxScreen extends StatelessWidget {
  final File imageFile;
  final Widget child;

  ImageBoundingBoxScreen({
    super.key,
    required this.imageFile,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            Image.file(imageFile),
            child,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pop(true);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
