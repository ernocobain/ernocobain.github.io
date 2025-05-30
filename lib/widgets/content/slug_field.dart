import 'package:flutter/material.dart';

class SlugField extends StatelessWidget {
  final TextEditingController controller;

  const SlugField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Slug',
        hintText: 'contoh: artikel-pertama',
        border: OutlineInputBorder(),
      ),
    );
  }
}
