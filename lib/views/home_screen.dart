import 'package:cms_flutter/views/article_list_page.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Artikel'),
      ),
      drawer: const AppDrawer(),
      body: const ArticleListPage(),
    );
  }
}