import 'package:flutter/material.dart';
import 'package:minimalist_weather/apis/geocoding_api.dart';
import 'package:minimalist_weather/apis/weather_api.dart';

@immutable
class City {
  final GeoLocation location;
  final WeatherData weather;

  const City({
    required this.location,
    required this.weather,
  });
}
