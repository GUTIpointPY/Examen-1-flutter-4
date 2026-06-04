import 'package:flutter/material.dart';
import 'presentation/pages/shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "L'Amour Shop",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const ShopPage(),
    );
  }
}
