import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_guys/core/app_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/domain/sales_order.dart';
import 'package:six_guys/ui/camera/painters/text_detector_painter.dart';
import 'package:six_guys/ui/scan/widgets/content_box_widget.dart';
import 'package:six_guys/ui/widgets/loading_widget.dart';
import 'package:six_guys/utils/erpnext_api.dart';
import 'package:six_guys/utils/nlp_plugin.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  late final _SalesOrderTextFieldControllers controllers;

  @override
  void initState() {
    super.initState();
    controllers = _SalesOrderTextFieldControllers()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final nlpPlugin = ref.watch(nlpPluginProvider);
    final erpNextApi = ref.watch(erpApiProvider);

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

                        final salesOrder = await globalLoadingNotifier.startLoadingWithTimeoutAndReturnResult(
                          () async => await nlpPlugin.getClassResult(nlpPlugin.getPrompt(recognizedText.text), SalesOrder.fromJson),
                        );
                        if (salesOrder == null) return;

                        _fillTextFields(salesOrder, controllers);
                        setState(() {});
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
                ContentBoxWidget(
                  title: "Customer",
                  controller: controllers.customerController,
                ),
                const SizedBox(height: 20),
                ContentBoxWidget(
                  title: "Transaction Date",
                  controller: controllers.transactionDateController,
                ),
                const SizedBox(height: 20),
                ContentBoxWidget(
                  title: "Currency",
                  controller: controllers.currencyController,
                ),
                const SizedBox(height: 20),
                ContentBoxWidget(
                  title: "Selling Price List",
                  controller: controllers.sellingPriceListController,
                ),
                ...controllers.items.map((e) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      ContentBoxWidget(
                        title: "Item ${controllers.items.indexOf(e) + 1}",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controllers.items.remove(e);
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Icon(Icons.close, size: 30, color: Colors.red),
                              ),
                            ),
                            ContentBoxWidget(
                              title: "Item Code",
                              controller: e.itemCodeController,
                            ),
                            const SizedBox(height: 20),
                            ContentBoxWidget(
                              title: "Delivery Date",
                              controller: e.deliveryDateController,
                            ),
                            const SizedBox(height: 20),
                            ContentBoxWidget(
                              title: "Qty",
                              child: TextField(
                                controller: e.qtyController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ContentBoxWidget(
                              title: "Rate",
                              child: TextField(
                                controller: e.rateController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    controllers.addItemFields();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: const Text("Add Item", style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(erpApiProvider.notifier).scanAndSend(controllers.toSalesOrder());
        },
        child: const Icon(Icons.shortcut_sharp),
      ),
    );
  }
}

class _ItemTextFields {
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
}

class _SalesOrderTextFieldControllers extends ChangeNotifier {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController transactionDateController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController sellingPriceListController = TextEditingController();
  final List<_ItemTextFields> items = [];

  void addItemFields() {
    items.add(_ItemTextFields());
    notifyListeners();
  }

  SalesOrder toSalesOrder() {
    final items = this
        .items
        .map((e) => SalesOrderItem(
              itemCode: e.itemCodeController.text,
              deliveryDate: e.deliveryDateController.text,
              qty: double.parse(e.qtyController.text),
              rate: double.parse(e.rateController.text),
            ))
        .toList();

    return SalesOrder(
      customer: customerController.text,
      transactionDate: transactionDateController.text,
      currency: currencyController.text,
      sellingPriceList: sellingPriceListController.text,
      items: items,
    );
  }
}

void _fillTextFields(SalesOrder salesOrder, _SalesOrderTextFieldControllers controllers) {
  controllers.customerController.text = salesOrder.customer;
  controllers.transactionDateController.text = salesOrder.transactionDate;
  controllers.currencyController.text = salesOrder.currency;
  controllers.sellingPriceListController.text = salesOrder.sellingPriceList;

  controllers.items.clear();
  controllers.items.addAll(salesOrder.items.map((e) {
    final itemFields = _ItemTextFields();
    itemFields.itemCodeController.text = e.itemCode;
    itemFields.deliveryDateController.text = e.deliveryDate;
    itemFields.qtyController.text = e.qty.toString();
    itemFields.rateController.text = e.rate.toString();
    return itemFields;
  }));
}
