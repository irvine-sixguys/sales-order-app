import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/ui/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: Routes.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ));
