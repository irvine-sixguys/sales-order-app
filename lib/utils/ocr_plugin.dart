import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final OCRPluginProvider = Provider<OCRPlugin>((ref) => OCRPlugin());

class OCRPlugin {
  static const MethodChannel _channel = MethodChannel('ocr_plugin');

  Future<String> getOCRByPath(String imagePath) async {
    final String result = await _channel.invokeMethod('getOCRByPath', {"imagePath": imagePath});
    return result;
  }

  Future<String> getOCRByBytes(List<int> imageBytes) async {
    final String result = await _channel.invokeMethod('getOCRByBytes', {"imageBytes": imageBytes});
    return result;
  }
}
