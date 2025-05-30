import 'package:cms_flutter/views/home_screen.dart';
import 'package:cms_flutter/views/login_page.dart';
// import 'package:cms_flutter/views/home_screen.dart';
// import 'package:cms_flutter/views/editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CMS',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    routes:{'/': (context) => const LoginPage(),
    '/home': (context) => const HomeScreen(),} // ganti dengan widget halamanmu
    );
  }
}
