import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/core/app_router.dart';

class MenuButton extends StatelessWidget {
  final WidgetRef ref;
  final String title;
  final String route;

  const MenuButton({super.key, required this.ref, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ref.read(routerProvider).push(route);
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Text(title, style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }
}
