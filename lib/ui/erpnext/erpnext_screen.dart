import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/utils/erpnext_api.dart';

class ERPNextScreen extends ConsumerWidget {
  const ERPNextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final erpnextAPI = ref.watch(erpApiProvider);

    final urlTextController = TextEditingController(text: erpnextAPI.url);
    final usernameTextController = TextEditingController(text: erpnextAPI.username);
    final passwordTextController = TextEditingController(text: erpnextAPI.password);

    return Scaffold(
        appBar: AppBar(title: const Text("ERPNext Settings")),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text("ERPNext Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextField(
                          controller: urlTextController,
                          decoration: const InputDecoration(
                            labelText: 'ERPNext URL',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: usernameTextController,
                          decoration: const InputDecoration(
                            labelText: 'ERPNext Username',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordTextController,
                          decoration: const InputDecoration(
                            labelText: 'ERPNext Password',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              ref
                                  .read(erpApiProvider.notifier)
                                  .login(url: urlTextController.text, username: usernameTextController.text, password: passwordTextController.text);
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                child: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.white)),
                              ),
                            ))
                      ],
                    )))));
  }
}
