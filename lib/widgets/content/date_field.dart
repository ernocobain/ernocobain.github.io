import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;

  const DateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Tanggal',
        hintText: 'YYYY-MM-DD',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.datetime,
    );
  }
}
