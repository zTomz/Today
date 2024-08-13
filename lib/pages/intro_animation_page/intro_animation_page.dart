import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:today/core/config/constants.dart';
import 'package:today/core/services/vibration_service.dart';
import 'package:today/pages/cities_page/cities_page.dart';

class IntroAnimationPage extends StatefulWidget {
  const IntroAnimationPage({super.key});

  @override
  State<IntroAnimationPage> createState() => _IntroAnimationPageState();
}

class _IntroAnimationPageState extends State<IntroAnimationPage> {
  int progress = 0;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  Future<void> startTimer() async {
    while (progress < 6) {
      await Future.delayed(AnimationDurations.delay);

      setState(() {
        progress++;
      });
      VibrationService().vibrate();
    }

    await Future.delayed(AnimationDurations.animationLong);

    if (mounted) {
      logger.i("Navigating to CitiesPage...");

      // If in debug mode, do not replace the route. So the developer can go
      // back to the intro page.
      if (kDebugMode) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CitiesPage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CitiesPage(),
          ),
        );
      }
    } else {
      logger.e("Failed to navigate to CitiesPage. The context is not mounted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _FadeInText(isVisible: progress >= 1, text: "What "),
                _FadeInText(isVisible: progress >= 2, text: "is"),
              ],
            ),
            Row(
              children: [
                _FadeInText(isVisible: progress >= 3, text: "the "),
                _FadeInText(isVisible: progress >= 4, text: "weather "),
                _FadeInText(isVisible: progress >= 5, text: "like"),
              ],
            ),
            Hero(
              tag: 'app_title',
              child: _FadeInText(
                isVisible: progress >= 6,
                text: "today?",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadeInText extends StatelessWidget {
  final bool isVisible;
  final String text;
  final TextStyle? style;

  const _FadeInText({
    required this.isVisible,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: AnimationDurations.animation,
      child: Text(
        text,
        style: style ??
            Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
      ),
    );
  }
}
