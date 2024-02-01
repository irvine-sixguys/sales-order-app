import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/core/app_router.dart';

final modalsProvider = Provider<Modals>((ref) => Modals(ref.watch(navigatorKeyProvider).currentState?.context));

class Modals {
  final BuildContext? context;

  const Modals(this.context);

  void showMySnackBar(String message) {
    if (context == null || !context!.mounted) return;

    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
