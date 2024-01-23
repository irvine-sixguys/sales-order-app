import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

class DemoImageScreen extends StatelessWidget {
  const DemoImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(child: Image.asset("assets/demo/purchase_order.jpeg")),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () async {
                  final byteData = await rootBundle.load('assets/demo/purchase_order.jpeg');

                  final file = File('${(await getTemporaryDirectory()).path}/temp_asset');
                  await file.writeAsBytes(
                    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
                  );
                  context.pop(file);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
