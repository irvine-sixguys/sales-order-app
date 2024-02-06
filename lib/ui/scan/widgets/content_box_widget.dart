import 'package:flutter/material.dart';

class ContentBoxWidget extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final Widget? child;

  ContentBoxWidget({
    super.key,
    required this.title,
    this.controller,
    this.child,
  }) {
    assert(controller != null || child != null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: (child == null)
              ? SizedBox(
                  height: 15,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                )
              : child,
        ),
      ],
    );
  }
}
