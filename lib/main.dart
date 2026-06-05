import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/bloc/cart_provider.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
          primary: const Color(0xFFE91E63),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
