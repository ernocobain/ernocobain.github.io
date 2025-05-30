import 'package:cms_flutter/services/github_service.dart';
import 'package:cms_flutter/services/submit_services.dart';
import 'package:cms_flutter/widgets/app_drawer.dart';
import 'package:cms_flutter/widgets/content/parse_markdown.dart';
import 'package:cms_flutter/widgets/editor_controler.dart';
import 'package:cms_flutter/widgets/editor_form.dart';
import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget {
  final String? slug;
  final String? initialTitle;

  const EditorPage({super.key, this.slug, this.initialTitle});

  @override
  State<EditorPage> createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final editorController = EditorController();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    if (widget.slug != null) {
      _loadArticle(widget.slug!);
    } else {
      editorController.titleController.text = widget.initialTitle ?? '';
    }
  }

 Future<void> _loadArticle(String slug) async {
  setState(() => _isLoading = true);
  try {
    final base64Content = await GitHubService.getArticleContent(
      path: 'posts/$slug.md',
    );

    parseMarkdown(
      base64Content: base64Content,
      controller: editorController,
    );
  } catch (e) {
    debugPrint('Gagal memuat artikel: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}


  void clearForm() {
    editorController.titleController.clear();
    editorController.contentController.clear();
    editorController.slugController.clear();
    editorController.dateController.clear();
  }

  Future<void> _handleSubmit() async {
    final success = await uploadArticle(
      context,
      editorController.titleController.text,
      editorController.contentController.text,
      editorController.slugController.text,
    );
    if (success && widget.slug == null) clearForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.slug != null ? 'Edit Artikel' : 'Tulis Artikel'),
      ),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: EditorForm(
                  controller: editorController,
                  onSubmit: _handleSubmit,
                ),
              ),
    );
  }
}
