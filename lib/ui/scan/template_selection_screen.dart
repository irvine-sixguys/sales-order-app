import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_guys/domain/template.dart';
import 'package:six_guys/repo/template_repo.dart';
import 'package:six_guys/utils/modals.dart';

class TemplateSelectionScreen extends ConsumerStatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  ConsumerState<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends ConsumerState<TemplateSelectionScreen> {
  Map<String, List<Template>> templates = {};

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    final templateNames = await ref.read(templateRepoProvider).getTemplateNames();
    for (final name in templateNames) {
      final info = await ref.read(templateRepoProvider).getTemplateInfo(name);
      setState(() {
        templates[name] = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("template selection")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: templates.entries.map(
                (e) {
                  final template = e.value.first;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, template.name);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text("Template: ${template.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Image.memory(template.imageBytes),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ).toList()
                ..add(Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final controller = TextEditingController();

                        final answer = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Create New Template"),
                            content: TextField(
                              decoration: const InputDecoration(
                                labelText: "Template Name",
                              ),
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, controller.text.trim());
                                },
                                child: const Text("Create"),
                              ),
                            ],
                          ),
                        );
                        if (answer != null) {
                          Navigator.pop(context, answer);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "Create New Template",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
                ..add(Column(
                  children: [
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await ref.read(templateRepoProvider).removeAllTemplates();
                        ref.read(modalsProvider).showMySnackBar("All templates removed.");
                        loadTemplates();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[200],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "Remove All Templates",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            ),
          ),
        ),
      ),
    );
  }
}
