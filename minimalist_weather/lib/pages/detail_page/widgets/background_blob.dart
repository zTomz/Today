import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';

class BackgroundBlob extends StatelessWidget {
  const BackgroundBlob({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    
    return Positioned(
      top: -screenSize.width * 0.9,
      left: -screenSize.width / 2,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: screenSize.width * 2,
          height: screenSize.width * 2,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.85),
                primaryColor.withOpacity(0.7),
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
      ),
    );
  }
}
