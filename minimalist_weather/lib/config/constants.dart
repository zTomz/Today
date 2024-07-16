// Keys for shared preferences

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Shared preferences key for the list of cities
const String citiesSharedPrefsKey = 'cities';
const String useCelciusKey = 'use_celsius';

const double defaultBorderWidth = 0.2;
const double defaultBorderRadius = 12;
const double appBarHeight = 130;

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
