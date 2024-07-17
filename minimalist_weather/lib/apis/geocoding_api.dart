import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minimalist_weather/apis/api_exeptions.dart';
import 'package:timezone/standalone.dart' as tz;

abstract class GeocodingApi {
  static Future<List<GeoLocation>> getSuggestions(String value) async {
    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=10&language=en&format=json',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return ((json['results'] as List<dynamic>?) ?? [])
          .map((res) => GeoLocation.fromMap(res as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 400) {
      final reason = jsonDecode(response.body)["reason"];

      throw ApiExeption(reason);
    } else {
      throw UnknownApiExeption(response.statusCode);
    }
  }
}

class GeoLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double elevation;
  final String country;
  final int countryId;
  final String countryCode;
  final String timezone;
  final List<String> postcodes;

  tz.Location get timezoneLocation => tz.getLocation(timezone);

  DateTime get timezoneTime => tz.TZDateTime.now(timezoneLocation);

  String get timezoneTimeString =>
      "${timezoneTime.hour.toString().padLeft(2, '0')}:${timezoneTime.minute.toString().padLeft(2, '0')}";

  GeoLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.country,
    required this.countryId,
    required this.countryCode,
    required this.timezone,
    required this.postcodes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'country': country,
      'country_id': countryId,
      'country_code': countryCode,
      'timezone': timezone,
      'postcodes': postcodes,
    };
  }

  factory GeoLocation.fromMap(Map<String, dynamic> map) {
    return GeoLocation(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      elevation: map['elevation']?.toDouble() ?? 0.0,
      country: map['country'] ?? '',
      countryId: map['country_id'] ?? '',
      countryCode: map['country_code'] ?? '',
      timezone: map['timezone'] ?? '',
      postcodes: ((map['postcodes'] as List<dynamic>?) ?? [])
          .map((postcode) => postcode.toString())
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoLocation.fromJson(String source) =>
      GeoLocation.fromMap(json.decode(source));
}

