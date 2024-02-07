import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/ui/menu/widgets/MenuButton.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text("Six Guys")),
        body: const SafeArea(
            child: SingleChildScrollView(
                child: Center(
          child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text("Welcome to Six Guys", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("This is a order app for Six Guys", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  MenuButton(title: "Application Settings", route: "/erpnext"),
                  SizedBox(height: 20),
                  MenuButton(title: "Order Paper Scan", route: "/scan")
                ],
              )),
        ))));
  }
}
