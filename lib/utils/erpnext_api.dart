import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final erpApiProvider = StateNotifierProvider<ERPAPINotifier, ERPNextAPI>((ref) => ERPAPINotifier());

class ERPAPINotifier extends StateNotifier<ERPNextAPI> {
  final _dio = Dio();
  ERPAPINotifier() : super(ERPNextAPI());

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
      print(response.headers["set-cookie"]);
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
    this.url = "http://localhost:8000",
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
