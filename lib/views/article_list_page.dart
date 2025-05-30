import 'package:cms_flutter/views/editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/github_service.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  List<String> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final articles = await GitHubService.listArticles(
        token: dotenv.env['GITHUB_TOKEN'] !, // Ganti tokenmu
        repo: 'dhikrama/cmsflutter',
      );
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching articles: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Artikel')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final fileName = _articles[index];
                  final slug = fileName.replaceAll('.md', '');
                  final title = slug.replaceAll('-', ' ');

                  return ListTile(
                    title: Text(title),
                    subtitle: Text('Slug: $slug'),
                    onTap: () {
                      final slug = fileName.replaceAll('.md', '');
                      final title = slug.replaceAll('-', ' ');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  EditorPage(slug: slug, initialTitle: title),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
