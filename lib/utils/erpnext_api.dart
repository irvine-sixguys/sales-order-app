import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/domain/sales_order.dart';
import 'package:six_guys/repo/template_repo.dart';
import 'package:six_guys/utils/modals.dart';

final erpApiProvider = StateNotifierProvider<ERPAPINotifier, ERPNextAPI>((ref) => ERPAPINotifier(ref));

class ERPAPINotifier extends StateNotifier<ERPNextAPI> {
  final _dio = Dio();
  // final adapter = BrowserHttpClientAdapter();
  final cookieJar = CookieJar();
  final Ref _ref;

  ERPAPINotifier(Ref ref)
      : _ref = ref,
        super(ERPNextAPI()) {
    // web
    // if (kIsWeb) {
    //   adapter.withCredentials = true;
    //   _dio.httpClientAdapter = adapter;
    // } else {
    _dio.interceptors.add(CookieManager(cookieJar));
    // }
  }

  Future login({
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
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ));
      final result = response.data as Map<String, dynamic>?;
      if (result != null && result["message"] != null) {
        _ref.read(modalsProvider).showMySnackBar(result["message"]);
      }
    } on DioException catch (e) {
      print(e);
      e.message != null ? _ref.read(modalsProvider).showMySnackBar(e.message!) : _ref.read(modalsProvider).showMySnackBar("Error logging in.");
    }
  }

  Future<void> scanAndSend(SalesOrder order) async {
    if (order.customer.trim().isEmpty) {
      _ref.read(modalsProvider).showMySnackBar("Please enter a customer name.");
      return;
    }

    try {
      final response = await _dio.post("${state.url}/api/resource/Sales%20Order",
          data: order.toJson(),
          options: Options(
            headers: {"Content-Type": "application/json", "Accept": "application/json"},
          ));
      print(response.data);
      _ref.read(modalsProvider).showMySnackBar("Sales Order created successfully.");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        _ref.read(modalsProvider).showMySnackBar("Connection Error. Please check your connection with ERPNext server.");
      }
      print(e);
      e.message != null ? _ref.read(modalsProvider).showMySnackBar(e.message!) : _ref.read(modalsProvider).showMySnackBar("Error creating Sales Order.");
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
    this.url = "https://curvy-pets-matter.loca.lt",
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
