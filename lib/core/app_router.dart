import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:six_guys/core/app_routes.dart';
import 'package:six_guys/ui/camera/demo_image_screen.dart';
import 'package:six_guys/ui/camera/image_bounding_box_screen.dart';
import 'package:six_guys/ui/home/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: Routes.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/bounding-box',
          name: Routes.boundingBox,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            final imageFile = args?['imageFile'] as File?;
            final child = args?['child'] as Widget?;

            if (imageFile == null || child == null) throw Exception("image or recognizedText is null");

            return ImageBoundingBoxScreen(
              imageFile: imageFile,
              child: child,
            );
          },
        ),
        GoRoute(
          path: '/demo',
          name: Routes.demo,
          builder: (context, state) => const DemoImageScreen(),
        ),
      ],
    ));
