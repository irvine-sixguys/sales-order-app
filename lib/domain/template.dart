import 'package:flutter/foundation.dart';

class Template {
  final String name;
  final Uint8List imageBytes;
  final String ocrResult;
  final String expectedLLMResult;

  const Template({
    required this.name,
    required this.imageBytes,
    required this.ocrResult,
    required this.expectedLLMResult,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    final imageBytes = List.castFrom<dynamic, int>(json['imageBytes'] as List<dynamic>);

    return Template(
      name: json['name'],
      imageBytes: Uint8List.fromList(imageBytes),
      ocrResult: json['ocrResult'],
      expectedLLMResult: json['expectedLLMResult'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageBytes': imageBytes,
      'ocrResult': ocrResult,
      'expectedLLMResult': expectedLLMResult,
    };
  }
}
