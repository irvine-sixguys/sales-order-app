import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/ui/menu/widgets/MenuButton.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text("Six Guys")),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
          child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text("Welcome to Six Guys", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("This is a demo app for Six Guys", style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  MenuButton(ref: ref, title: "ERPNext Settings", route: "/erpnext"),
                  const SizedBox(height: 20),
                  MenuButton(ref: ref, title: "Order Paper Scan", route: "/scan")
                ],
              )),
        ))));
  }
}
