import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listening App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Apple-style color palette: White/Beige driven
        scaffoldBackgroundColor: const Color(0xFFFDFCF8), // Warm white background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFCF6E3), // Beige seed
          primary: const Color(0xFF333333), // Soft black
          surface: Colors.white,
          background: const Color(0xFFFDFCF8),
          outline: const Color(0xFFE0E0E0),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Color(0xFF333333)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF333333),
          unselectedItemColor: Color(0xFFAAAAAA),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainPage(),
    );
  }
}