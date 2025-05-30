import 'package:cms_flutter/views/preview_page.dart';
import 'package:cms_flutter/widgets/content/date_field.dart';
import 'package:cms_flutter/widgets/content/slug_field.dart';
import 'package:cms_flutter/widgets/content/title_field.dart';
import 'package:cms_flutter/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import '../widgets/markdown_editor.dart';
import '../widgets/editor_controler.dart';

class EditorForm extends StatelessWidget {
  final EditorController controller;
  final VoidCallback onSubmit;

  const EditorForm({super.key, required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleField(controller: controller.titleController),
        const SizedBox(height: 12),
        SlugField(controller: controller.slugController),
        const SizedBox(height: 12),
        DateField(controller: controller.dateController),
        const SizedBox(height: 12),
        Expanded(child: MarkdownEditor(controller: controller.contentController)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PreviewPage(content: controller.contentController.text,),
              ),
            );
          },
          child: const Text('Lihat Preview'),
        ),
        const SizedBox(height: 16),
        SubmitButton(controller: controller),
      ],
    );
  }
}
