import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final prefsInstance = await SharedPreferences.getInstance();
    final List<String> cities =
        prefsInstance.getStringList(citiesSharedPrefsKey) ?? [];

    return cities;
  }

  /// Add a city to the list and save it to shared preferences.
  Future<void> addCity(String city) async {
    final cities = state.value ?? [];
    final prefsInstance = await SharedPreferences.getInstance();

    // Update the shared preferences
    await prefsInstance.setStringList(citiesSharedPrefsKey, [...cities, city]);
    // Update the app state
    state = AsyncValue.data([...cities, city]);
  }
}

final citiesProvider = AsyncNotifierProvider<CitiesNotifier, List<String>>(
  () => CitiesNotifier(),
);