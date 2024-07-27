import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundBlob extends StatelessWidget {
  /// The color of the background blob
  final Color color;

  /// The size of the background blob
  final Size size;

  const BackgroundBlob({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color,
              color.withOpacity(0.85),
              color.withOpacity(0.7),
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [
              0.05,
              0.3,
              0.5,
              0.85,
            ],
          ),
        ),
      ),
    );
  }
}
