import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:minimalist_weather/config/constants.dart';

class IntroAnimationPage extends HookWidget {
  const IntroAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wordProgress = useState<int>(1);

    // FIXME: Timer doesnt work
    // final _ = Timer.periodic(
    //   AnimationDurations.animationLong,
    //   (timer) {
    //     wordProgress.value += 1;

    //     if (wordProgress.value > 6) {
    //       timer.cancel();
    //       logger.i("Timer cancelled");
    //       Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (context) {
    //             return const CitiesPage();
    //           },
    //         ),
    //       );
    //     }
    //   },
    // );

    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenSize.width - Spacing.extraLarge,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
              children: [
                if (wordProgress.value >= 1)
                  const TextSpan(
                    text: "What ",
                  ),
                if (wordProgress.value >= 2)
                  const TextSpan(
                    text: "is\n",
                  ),
                if (wordProgress.value >= 3)
                  const TextSpan(
                    text: "the ",
                  ),
                if (wordProgress.value >= 4)
                  const TextSpan(
                    text: "weather ",
                  ),
                if (wordProgress.value >= 5)
                  const TextSpan(
                    text: "like\n",
                  ),
                if (wordProgress.value >= 6)
                  TextSpan(
                    text: "today?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
