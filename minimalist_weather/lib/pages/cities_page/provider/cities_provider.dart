import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/apis/geocoding_api.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/cities_page/provider/city.dart';
import 'package:open_meteo/apis/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesNotifier extends AsyncNotifier<List<City>> {
  @override
  Future<List<City>> build() async {
    final prefsInstance = await SharedPreferences.getInstance();
    final List<String> cityNames =
        prefsInstance.getStringList(citiesSharedPrefsKey) ?? [];
    List<City> cities = [];

    for (String city in cityNames) {
      // final location =
      // final weatherObj = Weather(
      //   latitude: location.latitude,
      //   longitude: location.longitude,
      // );
      // final result = await weatherObj.raw_request();
    }

    return cities;
  }

  /// Add a city to the list and save it to shared preferences.
  Future<void> addCity(GeoLocation city) async {
    final cities = state.value ?? [];
    final prefsInstance = await SharedPreferences.getInstance();
    await prefsInstance.clear();
    // Update the shared preferences
    await prefsInstance.setStringList(
      citiesSharedPrefsKey,
      [
        ...cities.map((e) => e.location.toJson()),
        city.toJson(),
      ],
    );
    // Update the app state
    // TODO: Get weather for the new city before adding it
    final newCity = City(
        location: city,
        weather: Weather(
          latitude: city.latitude,
          longitude: city.longitude,
        ));
    state = AsyncValue.data([
      ...cities,
      newCity,
    ]);
  }
}

final citiesProvider = AsyncNotifierProvider<CitiesNotifier, List<City>>(
  () => CitiesNotifier(),
);
