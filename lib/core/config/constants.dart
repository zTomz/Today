// Keys for shared preferences

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Shared preferences key for the list of cities
const String citiesSharedPrefsKey = 'cities';
const String useCelciusKey = 'use_celsius';

const double defaultBorderWidth = 0.2;
const double defaultBorderRadius = 12;
const double defaultAppBarHeight = 130;

/// A class, that contains all the animation duration constants used in the app
abstract class AnimationDurations {
  /// The duration for the animation
  static const Duration animation = Duration(milliseconds: 100);

  /// The duration for long animation's. Used in fade in
  static const Duration animationLong = Duration(milliseconds: 700);

  /// The delay, when multiple animations are played at the same time
  static const Duration delay = Duration(milliseconds: 200);

  /// Return the calculated delay for the animation, based on the provided index
  static Duration getDelayDuration(int index) {
    return delay * index;
  }
}

abstract class Spacing {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 28;
  static const double extraLarge = 40;
}

const Color primaryColor = Color(0xFFd77330);

Logger logger = Logger(
  filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(
    methodCount: 0,
  ), // Use the PrettyPrinter to format and print log
  output: null, // Use the default LogOutput (-> send everything to console)
);
