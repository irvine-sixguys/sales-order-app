import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageBoundingBoxScreen extends StatefulWidget {
  final File imageFile;

  const ImageBoundingBoxScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImageBoundingBoxScreen> createState() => _ImageBoundingBoxScreenState();
}

class _ImageBoundingBoxScreenState extends State<ImageBoundingBoxScreen> {
  final TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final imageKey = GlobalKey();
  InputImage? inputImage;
  RecognizedText? recognizedText;
  ui.Image? decodedImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  void _init() async {
    inputImage = InputImage.fromFile(widget.imageFile);
    recognizedText = await textRecognizer.processImage(inputImage!);
    decodedImage = await decodeImageFromList(widget.imageFile.readAsBytesSync());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            Image.file(key: imageKey, widget.imageFile),
            ...?recognizedText?.blocks.map(
              (e) {
                if (decodedImage == null) return const SizedBox();
                if (imageKey.currentContext == null) return const SizedBox();

                final originalSize = Size(decodedImage!.width.toDouble(), decodedImage!.height.toDouble());
                final box = imageKey.currentContext!.findRenderObject() as RenderBox;
                final imageSize = Size(box.size.width, box.size.height);
                final scale = Size(originalSize.width / imageSize.width, originalSize.height / imageSize.height);

                final rect = Rect.fromLTRB(
                  e.boundingBox.left / scale.width,
                  e.boundingBox.top / scale.height,
                  e.boundingBox.right / scale.width,
                  e.boundingBox.bottom / scale.height,
                );

                return Positioned(
                  left: rect.left,
                  top: rect.top,
                  width: rect.width,
                  height: rect.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pop(recognizedText?.text);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
