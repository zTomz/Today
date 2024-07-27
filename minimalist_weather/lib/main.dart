// TODO: Write README
// TODO: Write tests
// TODO: Add haptic feedback
// TODO: Add countdown text
// FIXME: Intro animation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/core/services/vibration_service.dart';
import 'package:minimalist_weather/pages/intro_animation_page/intro_animation_page.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  // Initialize the vibration service
  await VibrationService().init();

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
      title: 'Today',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 65,
            letterSpacing: 2,
          ),
          displaySmall: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        useMaterial3: true,
      ),
      home: const IntroAnimationPage(),
    );
  }
}
