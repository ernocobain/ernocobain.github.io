import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//upload article
Future<bool> uploadArticle(
  BuildContext context,
  String title,
  String content,
  String slug,
) async {
  final String token = dotenv.env['GITHUB_TOKEN']!;
  final String repo = 'dhikrama/fluttercms';
  final String author = 'dhikrama';
  final String branch = 'origin/main';

  final String filename = 'posts/$slug.md';
  final String url = 'https://api.github.com/repos/$repo/contents/$filename';

  final String date = DateTime.now().toIso8601String().split('T').first;
  final String markdown = '''
---
title: "$title"
slug: "$slug"
date: "$date"
---

$content
''';

  String? sha;
  final checkResponse = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    },
  );

  if (checkResponse.statusCode == 200) {
    final jsonBody = jsonDecode(checkResponse.body);
    sha = jsonBody['sha'];
  }

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    },
    body: jsonEncode({
      'message':
          sha == null ? 'Create new article: $title' : 'Update article: $title',
      'committer': {
        'name': author,
        'email': '${author.toLowerCase()}@example.com',
      },
      'content': base64.encode(utf8.encode(markdown)),
      'branch': branch,
      if (sha != null) 'sha': sha,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil disimpan')),
      );
    }
    return true;
  } else {
    debugPrint('Upload error: ${response.body}');
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan artikel')));
    }
    return false;
  }
}
