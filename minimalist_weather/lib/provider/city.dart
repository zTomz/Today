import 'package:flutter/material.dart';
import 'package:today/core/apis/geocoding_api.dart';
import 'package:today/core/apis/weather_api.dart';

@immutable
class City {
  final GeoLocation location;
  final WeatherData weather;
  final String uuid;

  const City({
    required this.location,
    required this.weather,
    required this.uuid,
  });
}
