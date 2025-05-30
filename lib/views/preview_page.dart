import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:markdown/markdown.dart' as md;

class PreviewPage extends StatelessWidget {
  final String content;

  const PreviewPage({super.key, required this.content,});

  @override
  Widget build(BuildContext context) {
    final html = md.markdownToHtml(content);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Artikel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: HtmlWidget(
          html,
          enableCaching: true,
          renderMode: RenderMode.column,
        ),
      ),
    );
  }
}
