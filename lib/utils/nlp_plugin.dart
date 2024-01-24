import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nlpPluginProvider = Provider<NLPPlugin>((ref) => NLPPlugin());

class NLPPlugin {
  final _apiKey = dotenv.env["OPENAI_API_KEY"];
  final _endPoint = "https://api.openai.com/v1/chat/completions";
  final _dio = Dio();

  Future<Map<String, dynamic>> getJsonResult(String prompt) async {
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
}
