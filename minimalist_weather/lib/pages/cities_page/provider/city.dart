import 'package:flutter/material.dart';
import 'package:minimalist_weather/apis/geocoding_api.dart';
import 'package:open_meteo/apis/weather.dart';

@immutable
class City {
  final GeoLocation location;
  final Weather weather;

  const City({
    required this.location,
    required this.weather,
  });
}
