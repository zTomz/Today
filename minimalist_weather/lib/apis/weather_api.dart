import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist_weather/apis/api_exeptions.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:qweather_icons/qweather_icons.dart';

abstract class WeatherApi {
  static const String _urlArgsString =
      '&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,rain,snowfall,snow_depth,weather_code,surface_pressure,wind_speed_10m&daily=sunrise,sunset,daylight_duration,sunshine_duration,uv_index_max,apparent_temperature_max,apparent_temperature_min,wind_speed_10m_max&start_date=2024-07-15&end_date=2024-07-17';

  static Future<WeatherData> getWeatherForCity({
    required Location location,
    bool useCelcius = true,
  }) async {
    var uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}$_urlArgsString${!useCelcius ? '&temperature_unit=fahrenheit' : ''}',
    );

    final response = await http.get(uri);

    int statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return WeatherData.fromJson(response.body);
    } else if (response.statusCode == 400) {
      final reason = jsonDecode(response.body)["reason"];

      throw ApiExeption(reason);
    } else {
      throw UnknownApiExeption(response.statusCode);
    }
  }

  static Future<List<WeatherData>> getWeatherForCities({
    required List<Location> locations,
    bool useCelcius = true,
  }) async {
    if (locations.isEmpty) {
      return [];
    }

    if (locations.length == 1) {
      return [
        await getWeatherForCity(
          location: locations.first,
          useCelcius: useCelcius,
        ),
      ];
    }

    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${locations.map((e) => e.latitude).join(",")}&longitude=${locations.map((e) => e.longitude).join(",")}$_urlArgsString${!useCelcius ? '&temperature_unit=fahrenheit' : ''}',
    );

    final response = await http.get(uri);

    int statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return (jsonDecode(response.body) as List)
          .map((element) => WeatherData.fromMap(element))
          .toList();
    } else if (response.statusCode == 400) {
      final reason = jsonDecode(response.body)["reason"];

      throw ApiExeption(reason);
    } else {
      throw UnknownApiExeption(response.statusCode);
    }
  }
}

@immutable
class Location {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });
}

@immutable
class WeatherData {
  final double latitude;
  final double longitude;
  final double generationtimeMs;
  final int utcOffsetSeconds;
  final String timezone;
  final String timezoneAbbreviation;
  final double elevation;

  // Units
  final String timeUnit;
  final String temperature2mUnit;
  final String relativeHumidity2mUnit;
  final String apparentTemperatureUnit;
  final String rainUnit;
  final String snowfallUnit;
  final String snowDepthUnit;
  final String weatherCodeUnit;
  final String surfacePressureUnit;
  final String windSpeed10mUnit;

  final List<HourlyWeatherData> hourlyWeatherData;
  final List<DailyWeatherData> dailyWeatherData;

  double get currentTemperature => currentHourlyWeatherData.temperature2m;

  HourlyWeatherData get currentHourlyWeatherData =>
      hourlyWeatherData[DateTime.now().hour];

  /// Returns a color for a weather code
  static Color getWeatherColor(int weatherCode) {
    if (weatherCode >= 0 && weatherCode <= 9) {
      return primaryColor;
      // return 'Clear or Sunny';
    } else if (weatherCode >= 10 && weatherCode <= 19) {
      return Colors.lightBlue[200]!;
      // return 'Partly Cloudy';
    } else if (weatherCode >= 20 && weatherCode <= 29) {
      return Colors.blue;
      // return 'Cloudy';
    } else if (weatherCode >= 30 && weatherCode <= 39) {
      return Colors.blue[700]!;
      // return 'Rain';
    } else if (weatherCode >= 40 && weatherCode <= 49) {
      return Colors.indigo[700]!;
      // return 'Thunderstorm';
    } else if (weatherCode >= 50 && weatherCode <= 59) {
      return Colors.lightBlue[200]!;
      // return 'Snow';
    } else if (weatherCode >= 60 && weatherCode <= 69) {
      return Colors.grey;
      // return 'Fog';
    } else if (weatherCode >= 70 && weatherCode <= 79) {
      return Colors.grey[800]!;
      // return 'Hail';
    } else if (weatherCode >= 80 && weatherCode <= 89) {
      return Colors.lightBlue[600]!;
      // return 'Sleet';
    } else if (weatherCode >= 90 && weatherCode <= 99) {
      return Colors.red[400]!;
      // return 'Extreme Weather';
    } else {
      return primaryColor;
      // return 'Unknown Weather Condition';
    }
  }

  /// Returns an icon for a weather code
  static Widget getWeatherIcon(int weatherCode) {
    if (weatherCode >= 0 && weatherCode <= 9) {
      return Icon(QWeatherIcons.tag_sunny.iconData);
      // return 'Clear or Sunny';
    } else if (weatherCode >= 10 && weatherCode <= 19) {
      return Icon(QWeatherIcons.tag_cloudy.iconData);
      // return 'Partly Cloudy';
    } else if (weatherCode >= 20 && weatherCode <= 29) {
      return Icon(QWeatherIcons.tag_overcast.iconData);
      // return 'Cloudy';
    } else if (weatherCode >= 30 && weatherCode <= 39) {
      return Icon(QWeatherIcons.tag_moderate_rain.iconData);
      // return 'Rain';
    } else if (weatherCode >= 40 && weatherCode <= 49) {
      return Icon(QWeatherIcons.tag_thundershower.iconData);
      // return 'Thunderstorm';
    } else if (weatherCode >= 50 && weatherCode <= 59) {
      return Icon(QWeatherIcons.tag_heavy_snow.iconData);
      // return 'Snow';
    } else if (weatherCode >= 60 && weatherCode <= 69) {
      return Icon(QWeatherIcons.tag_foggy.iconData);
      // return 'Fog';
    } else if (weatherCode >= 70 && weatherCode <= 79) {
      return Icon(QWeatherIcons.tag_hail.iconData);
      // return 'Hail';
    } else if (weatherCode >= 80 && weatherCode <= 89) {
      return Icon(QWeatherIcons.tag_sleet.iconData);
      // return 'Sleet';
    } else if (weatherCode >= 90 && weatherCode <= 99) {
      return Icon(QWeatherIcons.tag_disaster_risk_early_warning.iconData);
      // return 'Extreme Weather';
    } else {
      return Icon(QWeatherIcons.tag_unknown.iconData);
      // return 'Unknown Weather Condition';
    }
  }

  /// Returns an icon for a weather code
  static String getWeatherDescription(int weatherCode) {
    if (weatherCode >= 0 && weatherCode <= 9) {
      return 'Sunny';
    } else if (weatherCode >= 10 && weatherCode <= 19) {
      return 'Partly Cloudy';
    } else if (weatherCode >= 20 && weatherCode <= 29) {
      return 'Cloudy';
    } else if (weatherCode >= 30 && weatherCode <= 39) {
      return 'Rain';
    } else if (weatherCode >= 40 && weatherCode <= 49) {
      return 'Thunderstorm';
    } else if (weatherCode >= 50 && weatherCode <= 59) {
      return 'Snow';
    } else if (weatherCode >= 60 && weatherCode <= 69) {
      return 'Fog';
    } else if (weatherCode >= 70 && weatherCode <= 79) {
      return 'Hail';
    } else if (weatherCode >= 80 && weatherCode <= 89) {
      return 'Sleet';
    } else if (weatherCode >= 90 && weatherCode <= 99) {
      return 'Extreme Weather';
    } else {
      return 'Unknown Weather Condition';
    }
  }

  const WeatherData({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.timeUnit,
    required this.temperature2mUnit,
    required this.relativeHumidity2mUnit,
    required this.apparentTemperatureUnit,
    required this.rainUnit,
    required this.snowfallUnit,
    required this.snowDepthUnit,
    required this.weatherCodeUnit,
    required this.surfacePressureUnit,
    required this.windSpeed10mUnit,
    required this.hourlyWeatherData,
    required this.dailyWeatherData,
  });

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    // Parse the hourly data
    final List<DateTime> time = (map['hourly']['time'] as List<dynamic>)
        .map((element) => DateTime.parse(element.toString()))
        .toList();
    final List<double> temperature2m =
        map['hourly']['temperature_2m'].cast<double>();
    final List<int> relativeHumidity2m =
        map['hourly']['relative_humidity_2m'].cast<int>();
    final List<double> apparentTemperature =
        map['hourly']['apparent_temperature'].cast<double>();
    final List<double> rain = map['hourly']['rain'].cast<double>();
    final List<double> snowfall = map['hourly']['snowfall'].cast<double>();
    final List<double> snowDepth = map['hourly']['snow_depth'].cast<double>();
    final List<int> weatherCode = map['hourly']['weather_code'].cast<int>();
    final List<double> surfacePressure =
        map['hourly']['surface_pressure'].cast<double>();
    final List<double> windSpeed10m =
        map['hourly']['wind_speed_10m'].cast<double>();

    List<HourlyWeatherData> hourlyWeatherData = [];
    for (var i = 0; i < time.length; i++) {
      hourlyWeatherData.add(
        HourlyWeatherData(
          time: time[i],
          temperature2m: temperature2m[i],
          relativeHumidity2m: relativeHumidity2m[i],
          apparentTemperature: apparentTemperature[i],
          rain: rain[i],
          snowfall: snowfall[i],
          snowDepth: snowDepth[i],
          weatherCode: weatherCode[i],
          surfacePressure: surfacePressure[i],
          surfacePressureUnit: map['hourly_units']['surface_pressure'],
          windSpeed10m: windSpeed10m[i],
          windSpeed10mUnit: map['hourly_units']['wind_speed_10m'],
        ),
      );
    }

    // Parse the daily data
    final List<DateTime> date = (map['daily']['time'] as List<dynamic>)
        .map((element) => DateTime.parse(element.toString()))
        .toList();

    final List<DateTime> sunrise = (map['daily']['sunrise'] as List<dynamic>)
        .map((element) => DateTime.parse(element.toString()))
        .toList();

    final List<DateTime> sunset = (map['daily']['sunset'] as List<dynamic>)
        .map((element) => DateTime.parse(element.toString()))
        .toList();

    final List<double> daylightDuration =
        map['daily']['daylight_duration'].cast<double>();
    final List<double> sunshineDuration =
        map['daily']['sunshine_duration'].cast<double>();
    final List<double> uvIndexMax = map['daily']['uv_index_max'].cast<double>();
    final List<double> apparentTemperatureMin =
        map['daily']['apparent_temperature_min'].cast<double>();
    final List<double> apparentTemperatureMax =
        map['daily']['apparent_temperature_max'].cast<double>();
    final List<double> windSpeed10mMax =
        map['daily']['wind_speed_10m_max'].cast<double>();

    // Units
    final String daylightDurationUnit =
        map['daily_units']['daylight_duration'] as String;
    final String sunshineDurationUnit =
        map['daily_units']['sunshine_duration'] as String;

    List<DailyWeatherData> dailyWeatherData = [];
    for (var i = 0; i < date.length; i++) {
      dailyWeatherData.add(
        DailyWeatherData(
          date: date[i],
          sunrise: sunrise[i],
          sunset: sunset[i],
          daylightDuration: daylightDuration[i],
          sunshineDuration: sunshineDuration[i],
          uvIndexMax: uvIndexMax[i],
          apparentTemperatureMin: apparentTemperatureMin[i],
          apparentTemperatureMax: apparentTemperatureMax[i],
          windSpeed10mMax: windSpeed10mMax[i],
          daylightDurationUnit: daylightDurationUnit,
          sunshineDurationUnit: sunshineDurationUnit,
        ),
      );
    }

    return WeatherData(
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      generationtimeMs: map['generationtime_ms'].toDouble(),
      utcOffsetSeconds: map['utc_offset_seconds'].toInt(),
      timezone: map['timezone'],
      timezoneAbbreviation: map['timezone_abbreviation'],
      elevation: map['elevation'].toDouble(),
      timeUnit: map['hourly_units']['time'],
      temperature2mUnit: map['hourly_units']['temperature_2m'],
      relativeHumidity2mUnit: map['hourly_units']['relative_humidity_2m'],
      apparentTemperatureUnit: map['hourly_units']['apparent_temperature'],
      rainUnit: map['hourly_units']['rain'],
      snowfallUnit: map['hourly_units']['snowfall'],
      snowDepthUnit: map['hourly_units']['snow_depth'],
      weatherCodeUnit: map['hourly_units']['weather_code'],
      surfacePressureUnit: map['hourly_units']['surface_pressure'],
      windSpeed10mUnit: map['hourly_units']['wind_speed_10m'],
      hourlyWeatherData: hourlyWeatherData,
      dailyWeatherData: dailyWeatherData,
    );
  }

  factory WeatherData.fromJson(String source) =>
      WeatherData.fromMap(json.decode(source));
}

@immutable
class HourlyWeatherData {
  final DateTime time;
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final double rain;
  final double snowfall;
  final double snowDepth;
  final int weatherCode;
  final double surfacePressure;
  final String surfacePressureUnit;
  final double windSpeed10m;
  final String windSpeed10mUnit;

  const HourlyWeatherData({
    required this.time,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.rain,
    required this.snowfall,
    required this.snowDepth,
    required this.weatherCode,
    required this.surfacePressure,
    required this.surfacePressureUnit,
    required this.windSpeed10m,
    required this.windSpeed10mUnit,
  });

  Color get weatherColor {
    return WeatherData.getWeatherColor(weatherCode);
  }

  Widget get weatherIcon {
    return WeatherData.getWeatherIcon(weatherCode);
  }

  String get weatherDescription {
    return WeatherData.getWeatherDescription(weatherCode);
  }

  factory HourlyWeatherData.fromMap(Map<String, dynamic> map) {
    return HourlyWeatherData(
      time: DateTime.parse(map['time']),
      temperature2m: map['temperature_2m'].toDouble(),
      relativeHumidity2m: map['relative_humidity_2m'].toInt(),
      apparentTemperature: map['apparent_temperature'].toDouble(),
      rain: map['rain'].toDouble(),
      snowfall: map['snowfall'].toDouble(),
      snowDepth: map['snow_depth'].toDouble(),
      weatherCode: map['weather_code'].toInt(),
      surfacePressure: map['surface_pressure'].toDouble(),
      surfacePressureUnit: map['surface_pressure_unit'] as String,
      windSpeed10m: map['wind_speed_10m'].toDouble(),
      windSpeed10mUnit: map['wind_speed_10m_unit'] as String,
    );
  }

  factory HourlyWeatherData.fromJson(String source) =>
      HourlyWeatherData.fromMap(json.decode(source));
}

@immutable
class DailyWeatherData {
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final double daylightDuration;
  final double sunshineDuration;
  final double uvIndexMax;
  final double apparentTemperatureMax;
  final double apparentTemperatureMin;
  final double windSpeed10mMax;

  // Units
  final String daylightDurationUnit;
  final String sunshineDurationUnit;

  const DailyWeatherData({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.daylightDuration,
    required this.sunshineDuration,
    required this.uvIndexMax,
    required this.daylightDurationUnit,
    required this.sunshineDurationUnit,
    required this.apparentTemperatureMax,
    required this.apparentTemperatureMin,
    required this.windSpeed10mMax,
  });

  factory DailyWeatherData.fromMap(Map<String, dynamic> map) {
    return DailyWeatherData(
      date: DateTime.parse(map['date']),
      sunrise: DateTime.parse(map['sunrise']),
      sunset: DateTime.parse(map['sunset']),
      daylightDuration: map['daylight_duration'].toDouble(),
      sunshineDuration: map['sunshine_duration'].toDouble(),
      uvIndexMax: map['uv_index_max'].toDouble(),
      apparentTemperatureMax: map['apparent_temperature_max'].toDouble(),
      apparentTemperatureMin: map['apparent_temperature_min'].toDouble(),
      windSpeed10mMax: map['wind_speed_10m_max'].toDouble(),
      daylightDurationUnit: map['daylight_duration_unit'],
      sunshineDurationUnit: map['sunshine_duration_unit'],
    );
  }

  factory DailyWeatherData.fromJson(String source) =>
      DailyWeatherData.fromMap(json.decode(source));
}
