import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sections/portfolio_page.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAR Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F0EA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF522546)),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const PortfolioPage(),
    );
  }
}
