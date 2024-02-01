import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_guys/core/app_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/ui/camera/painters/text_detector_painter.dart';
import 'package:six_guys/ui/scan/widgets/content_box_widget.dart';
import 'package:six_guys/ui/widgets/loading_widget.dart';
import 'package:six_guys/utils/nlp_plugin.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    final nlpPlugin = ref.watch(nlpPluginProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Six Guys")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        final globalLoadingNotifier = ref.read(globalLoadingProvider.notifier);

                        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (pickedFile == null) return;

                        globalLoadingNotifier.startLoadingWithTimeout();
                        final rotatedImage = await FlutterExifRotation.rotateImage(path: pickedFile.path);
                        final inputImage = InputImage.fromFile(rotatedImage);

                        final imageBytes = await File(inputImage.filePath!).readAsBytes();
                        final decodedImage = await decodeImageFromList(imageBytes);
                        final height = decodedImage.height; // Image height
                        final width = decodedImage.width; // Image width

                        final recognizedText = await TextRecognizer(script: TextRecognitionScript.latin).processImage(inputImage);
                        final painter = TextRecognizerPainter(
                          recognizedText,
                          Size(width.toDouble(), height.toDouble()),
                          InputImageRotation.rotation0deg,
                          CameraLensDirection.back,
                        );
                        globalLoadingNotifier.stopLoading();

                        final answer = await ref.read(routerProvider).pushNamed<bool>(Routes.boundingBox, extra: {
                          "imageFile": rotatedImage,
                          "child": AspectRatio(
                            aspectRatio: width / height,
                            child: CustomPaint(painter: painter),
                          ),
                        });

                        if (answer == null || !answer) return;

                        final res = await globalLoadingNotifier.startLoadingWithTimeoutAndReturnResult(
                          () async => await nlpPlugin.getJsonResult("extract useful information from the following Purchase Order OCR:\n${recognizedText.text}"),
                        );
                        print(res);
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const ContentBoxWidget(title: "Name", child: Text("Logan Ahn")),
                const SizedBox(height: 20),
                const ContentBoxWidget(title: "Email", child: Text("example@gmail.com")),
                const SizedBox(height: 20),
                const ContentBoxWidget(title: "Ship to", child: Text("Haskel International 100 E. Graham Place Burbank CA 91502 USA")),
                const SizedBox(height: 20),
                const ContentBoxWidget(
                  title: "Item 1",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContentBoxWidget(title: "ID", child: Text("568037-27")),
                      SizedBox(height: 20),
                      ContentBoxWidget(title: "Description", child: Text("O RING")),
                      SizedBox(height: 20),
                      ContentBoxWidget(title: "Quantity", child: Text("1")),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const ContentBoxWidget(
                  title: "Item 2",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContentBoxWidget(title: "ID", child: Text("568037-28")),
                      SizedBox(height: 20),
                      ContentBoxWidget(title: "Description", child: Text("O RING")),
                      SizedBox(height: 20),
                      ContentBoxWidget(title: "Quantity", child: Text("1")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
