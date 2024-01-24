import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/core/app_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/ui/home/widgets/content_box_widget.dart';
import 'package:six_guys/utils/nlp_plugin.dart';
import 'package:six_guys/utils/ocr_plugin.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        final File? image = await ref.read(routerProvider).pushNamed(Routes.camera);
                        // final File? image = await ref.read(routerProvider).pushNamed(Routes.demo);
                        if (image == null) return;

                        final result = await ref.read(OCRPluginProvider).getOCRByFile(image);
                        final answer = await nlpPlugin.getJsonResult("extract useful information from the following Purchase Order OCR:\n${result.text}");
                        print(answer);
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
