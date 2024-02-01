import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/domain/sales_order.dart';

final erpApiProvider = StateNotifierProvider<ERPAPINotifier, ERPNextAPI>((ref) => ERPAPINotifier());

class ERPAPINotifier extends StateNotifier<ERPNextAPI> {
  final _dio = Dio();
  final adapter = BrowserHttpClientAdapter();
  final cookieJar = CookieJar();

  ERPAPINotifier() : super(ERPNextAPI()) {
    if (kIsWeb) {
      adapter.withCredentials = true;
      _dio.httpClientAdapter = adapter;
    } else {
      _dio.interceptors.add(CookieManager(cookieJar));
    }
  }

  void login({
    required String url,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      url: url,
      username: username,
      password: password,
    );

    try {
      final response = await _dio.post("${state.url}/api/method/login",
          data: {
            "usr": state.username,
            "pwd": state.password,
          },
          options: Options(
            headers: {"Content-Type": "application/json", "Accept": "application/json"},
          ));
      print(response.data);
    } on DioException catch (e) {
      print(e);
    }
  }

  void scanAndSend(SalesOrder order) async {
    try {
      final response = await _dio.post("${state.url}/api/resource/Sales%20Order",
          data: order.toJson(),
          options: Options(
            headers: {"Content-Type": "application/json", "Accept": "application/json"},
          ));
    } on DioException catch (e) {
      print(e);
    }
  }

  void changeUrl(String url) {
    state = state.copyWith(url: url);
  }

  void logout() {
    state = ERPNextAPI();
  }
}

class ERPNextAPI {
  final String url;
  final String username;
  final String password;
  final String? loginCookie;

  ERPNextAPI({
    this.url = "http://192.168.86.32:7000",
    this.username = "Administrator",
    this.password = "admin",
    this.loginCookie,
  });

  ERPNextAPI copyWith({
    String? url,
    String? username,
    String? password,
    String? loginCookie,
  }) {
    return ERPNextAPI(
      url: url ?? this.url,
      username: username ?? this.username,
      password: password ?? this.password,
      loginCookie: loginCookie ?? this.loginCookie,
    );
  }
}
