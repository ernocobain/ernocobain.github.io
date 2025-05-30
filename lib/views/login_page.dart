import 'package:cms_flutter/services/auth/github_login_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GitHubLoginButton();
  }
}