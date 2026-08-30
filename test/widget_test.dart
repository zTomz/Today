import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:today/core/config/constants.dart';
import 'package:today/pages/intro_animation_page/intro_animation_page.dart';

void main() {
  testWidgets('shows the intro screen', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: IntroAnimationPage()));

    expect(find.text('What '), findsOneWidget);
    expect(find.text('today?'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(AnimationDurations.delay);
  });
}
