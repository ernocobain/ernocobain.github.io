import 'package:flutter/material.dart';

class MarkdownEditor extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownEditor({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 10,
      decoration: const InputDecoration(
        labelText: 'Konten Markdown',
        border: OutlineInputBorder(),
      ),
    );
  }
}
