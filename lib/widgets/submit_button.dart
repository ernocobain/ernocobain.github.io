import 'package:cms_flutter/services/submit_services.dart';
import 'package:flutter/material.dart';
import '../widgets/editor_controler.dart';

class SubmitButton extends StatelessWidget {
  final EditorController controller;

  const SubmitButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final title = controller.titleController.text;
        final slug = controller.slugController.text;
        final content = controller.contentController.text;

        final success = await uploadArticle(
          context,
          title,
          content,
          slug,
        );

        if (success) {
          if (!context.mounted) return;
          Navigator.pop(context);
        }
      },
      child: const Text('Simpan Artikel'),
    );
  }
}
