import 'package:flutter/material.dart';
import 'views/auth_screen.dart'; // Import màn hình Đăng nhập

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng Đăng Nhập',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}