import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/apis/geocoding_api.dart';
import 'package:minimalist_weather/apis/weather_api.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/provider/city.dart';
import 'package:shared_preferences/shared_preferences.dart';

// All cities are stored as json [GeoLocation] data

class CitiesNotifier extends AsyncNotifier<List<City>> {
  @override
  Future<List<City>> build() async {
    final prefsInstance = await SharedPreferences.getInstance();
    final List<String> cityNames =
        prefsInstance.getStringList(citiesSharedPrefsKey) ?? [];
    final List<GeoLocation> geoLocations =
        cityNames.map((city) => GeoLocation.fromJson(city)).toList();
    final List<WeatherData> weatherData = await WeatherApi.getWeatherForCities(
      locations: geoLocations
          .map(
            (location) => Location(
                latitude: location.latitude, longitude: location.longitude),
          )
          .toList(),
    );
    List<City> cities = [];

    for (int i = 0; i < geoLocations.length; i++) {
      cities.add(
        City(
          location: geoLocations[i],
          weather: weatherData[i],
        ),
      );
    }

    return cities;
  }

  /// Add a city to the list and save it to shared preferences.
  Future<void> addCity(GeoLocation location) async {
    final cities = state.value ?? [];
    final prefsInstance = await SharedPreferences.getInstance();
    await prefsInstance.clear();

    // Update the shared preferences
    await prefsInstance.setStringList(
      citiesSharedPrefsKey,
      [
        ...cities.map((e) => e.location.toJson()),
        location.toJson(),
      ],
    );
    // Update the app state
    // TODO: Handle errors
    final newCity = City(
      location: location,
      weather: await WeatherApi.getWeatherForCity(
        location: Location(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      ),
    );
    state = AsyncValue.data([
      ...cities,
      newCity,
    ]);
  }
}

final citiesProvider = AsyncNotifierProvider<CitiesNotifier, List<City>>(
  () => CitiesNotifier(),
);
