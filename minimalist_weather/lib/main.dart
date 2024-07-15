// TODO: Configure geolocator for ios

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/pages/cities_page/cities_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 65,
            letterSpacing: 2,
          ),
          displaySmall: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
        useMaterial3: true,
      ),
      home: const CitiesPage(),
    );
  }
}
