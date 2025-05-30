import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class GitHubLoginButton extends StatelessWidget {
  const GitHubLoginButton({super.key});

  Future<void> _loginWithGitHub(BuildContext context) async {
    final clientId = dotenv.env['CLIENT_ID']!;
    final clientSecret = dotenv.env['CLIENT_SECRET']!;
    const redirectUri =
        'myapp://callback'; // sama dengan yang kamu daftarkan di GitHub
    const scope = 'repo user'; // sesuaikan dengan kebutuhan kamu

    final authUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=$scope';

    try {
      // Langkah 1: buka GitHub login
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'myapp',
      );

      // Langkah 2: ambil code dari callback
      final code = Uri.parse(result).queryParameters['code'];

      if (code == null) {
        throw Exception('Code tidak ditemukan dalam URL callback.');
      }

      // Langkah 3: tukar code menjadi access_token
      final response = await http.post(
        Uri.parse('https://github.com/login/oauth/access_token'),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      final token = body['access_token'];

      if (token == null) {
        throw Exception('Token tidak ditemukan. Response: ${response.body}');
      }

      debugPrint('Login sukses! Token: $token');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

      if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login berhasil!')));
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _loginWithGitHub(context),
      icon: const Icon(Icons.login),
      label: const Text('Login dengan GitHub'),
    );
  }
}
