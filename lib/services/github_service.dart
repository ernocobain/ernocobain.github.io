import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  // upload content ke github

  static Future<bool> uploadToGitHub({
    required String token,
    required String repo,
    required String path,
    required String content,
    required String commitMessage,
  }) async {
    final apiUrl = 'https://api.github.com/repos/$repo/contents/$path';
    final base64Content = base64Encode(utf8.encode(content));

    // Cek apakah file sudah ada
    final getResponse = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
    );

    String? sha;
    if (getResponse.statusCode == 200) {
      final data = json.decode(getResponse.body);
      sha = data['sha'];
    }

    final body = {
      "message": commitMessage,
      "content": base64Content,
      if (sha != null) "sha": sha,
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  //Menampilkan list article dari github

  static Future<List<String>> listArticles({
    required String token,
    required String repo,
    String path = 'posts',
  }) async {
    final url = Uri.https('api.github.com', '/repos/$repo/contents/$path');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final files =
          data
              .where(
                (item) =>
                    item['type'] == 'file' && item['name'].endsWith('.md'),
              )
              .map<String>((item) => item['name'] as String)
              .toList();
      return files;
    } else {
      throw Exception('Gagal mengambil daftar artikel');
    }
  }

  // Menampilkan article detail dari github
static Future<String> getArticleContent({required String path}) async {
  final String token = dotenv.env['GITHUB_TOKEN']!;
  final String repo = 'dhikrama/cmsflutter';
  final url = Uri.parse('https://api.github.com/repos/$repo/contents/$path');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['content']; // HANYA ambil base64 content
  } else {
    debugPrint('Error ${response.statusCode}: ${response.body}');
    throw Exception('Gagal mengambil artikel: ${response.statusCode}');
  }
}



  // Mendapatk slug dari article
  static Future<String> getArticleBySlug(String slug) {
    return getArticleContent(path: 'posts/$slug.md');
  }

  // Menghapus article

  static Future<bool> deleteArticle({
    required String token,
    required String repo,
    required String path,
  }) async {
    final uri = Uri.parse('https://api.github.com/repos/$repo/contents/$path');

    try {
      // 1. Ambil SHA file dulu
      final getRes = await http.get(
        uri,
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (getRes.statusCode != 200) {
        debugPrint('Gagal mendapatkan SHA: ${getRes.body}');
        return false;
      }

      final sha = jsonDecode(getRes.body)['sha'];

      // 2. Kirim request DELETE dengan SHA
      final deleteRes = await http.delete(
        uri,
        headers: {
          'Authorization': 'token $token',
          'Accept': 'application/vnd.github.v3+json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': 'delete post: $path', 'sha': sha}),
      );

      if (deleteRes.statusCode == 200) {
        return true;
      } else {
        debugPrint('Gagal menghapus artikel: ${deleteRes.body}');
        debugPrint('Status delete: ${deleteRes.statusCode}');
        debugPrint('Response delete: ${deleteRes.body}');
        if (kDebugMode) {
          print('Response body: ${deleteRes.body}))');
        }

        return false;
      }
    } catch (e) {
      debugPrint('Error saat delete article: $e');

      return false;
    }
  }
  
}
