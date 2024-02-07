import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/domain/template.dart';

final nlpPluginProvider = Provider<NLPPlugin>((ref) => NLPPlugin());

class NLPPlugin {
  final _apiKey = dotenv.env["OPENAI_API_KEY"];
  final _endPoint = "https://api.openai.com/v1/chat/completions";
  final _dio = Dio();

  /// method which return the Class <T> object
  /// [prompt] is the string to be sent to the OpenAI API
  /// [T] is the type of the object to be returned
  /// [T] must be a class with a factory constructor that takes a Map<String, dynamic>
  Future<T?> getClassResult<T>(
    String prompt,
    T Function(Map<String, dynamic>) fromJson, {
    int retryCount = 2,
  }) async {
    try {
      final json = await _getJsonResult(prompt);
      return fromJson(json);
    } catch (e) {
      if (retryCount > 0) {
        return getClassResult(prompt, fromJson, retryCount: retryCount - 1);
      } else {
        return null;
      }
    }
  }

  Future<Map<String, dynamic>> _getJsonResult(String prompt) async {
    final result = await _dio.post(
      _endPoint,
      data: {
        "model": "gpt-3.5-turbo-1106",
        "response_format": {"type": "json_object"},
        "messages": [
          {"role": "system", "content": "You are a helpful assistant designed to output JSON."},
          {"role": "user", "content": prompt}
        ]
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
      ),
    );

    return jsonDecode(result.data["choices"][0]["message"]["content"]);
  }

  String getPrompt(String ocr) {
    return """\
Following is the sales order format:
{
    "data": {
        "customer": "Yany", // 필수
        "transaction_date": "2024-01-15",
        "currency": "USD",
        "selling_price_list": "Standard Selling",
        "items": [
            {
                "item_code": "777",
                "delivery_date": "2024-01-16",
                "qty": 1.0,
                "rate": 5.0
            },
            {
                "item_code": "777",
                "delivery_date": "2024-01-16",
                "qty": 2.0,
                "rate": 5.0
            }
        ]
    }
}
---
Return the sales order details for the following OCR result:
$ocr
""";
  }

  String getPromptWithTemplate(String ocr, List<Template> templates) {
    if (templates.isEmpty) return getPrompt(ocr);

    return """\
${templates.map((template) => "---\nReturn the sales order details for the following OCR result:\n${template.ocrResult}\n${template.expectedLLMResult}").join("\n---\n")}
---
Return the sales order details for the following OCR result:
$ocr
""";
  }
}
