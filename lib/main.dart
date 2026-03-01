import 'package:flutter/material.dart';
import 'pages/janken_page.dart';
import 'styles/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '猜拳',
      theme: AppStyles.theme,
      home: const JankenPage(),
    );
  }
}
