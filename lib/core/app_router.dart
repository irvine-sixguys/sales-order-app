import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/ui/camera/camera_screen.dart';
import 'package:six_guys/ui/camera/demo_image_screen.dart';
import 'package:six_guys/ui/home/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: Routes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/camera',
          name: Routes.camera,
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: '/demo',
          name: Routes.demo,
          builder: (context, state) => const DemoImageScreen(),
        ),
      ],
    ));
