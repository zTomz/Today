import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/core/exeptions/api_exeptions.dart';
import 'package:minimalist_weather/core/apis/geocoding_api.dart';
import 'package:minimalist_weather/core/apis/weather_api.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/core/exeptions/cities_provider_exeptions.dart';
import 'package:minimalist_weather/provider/city.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// All cities are stored as json [GeoLocation] data

class CitiesNotifier extends AsyncNotifier<List<City>> {
  @override
  Future<List<City>> build() async {
    final prefsInstance = await SharedPreferences.getInstance();

    // Get `useCelcius` value
    final useCelcius = prefsInstance.getBool(useCelciusKey) ?? true;
    ref.read(useCelciusProvider.notifier).state = useCelcius;
    logger.i("Loaded useCelcius: $useCelcius");

    // Get geo locations
    final List<String> loadedGeoLocations =
        prefsInstance.getStringList(citiesSharedPrefsKey) ?? [];
    final List<GeoLocation> geoLocations = loadedGeoLocations
        .map((location) => GeoLocation.fromJson(location))
        .toList();
    logger.i("Loaded geo locations");

    // Load the weather data
    final List<WeatherData> weatherData = await WeatherApi.getWeatherForCities(
      locations: geoLocations
          .map(
            (location) => Location(
              latitude: location.latitude,
              longitude: location.longitude,
            ),
          )
          .toList(),
      useCelcius: useCelcius,
    );
    logger.i("Got weather data");

    List<City> cities = [];

    for (int i = 0; i < geoLocations.length; i++) {
      cities.add(
        City(
          location: geoLocations[i],
          weather: weatherData[i],
          uuid: const Uuid().v4(),
        ),
      );
    }

    return cities;
  }

  /// Add a city to the list and save it to shared preferences.
  Future<void> addCity(GeoLocation location) async {
    final cities = state.value ?? [];

    if (cities.any((element) => element.location.latitude == location.latitude && element.location.longitude == location.longitude)) {
      logger.e("The city ${location.name}, ${location.countryCode} already exists");
      throw CityAlreadyExistsExeption(
        message: "The city ${location.name}, ${location.countryCode} already exists",
      );
    }

    final prefsInstance = await SharedPreferences.getInstance();

    // Update the shared preferences
    await prefsInstance.setStringList(
      citiesSharedPrefsKey,
      [
        ...cities.map((e) => e.location.toJson()),
        location.toJson(),
      ],
    );
    logger.i("Saved new city to shared preferences");

    // Update the app state
    try {
      final weatherData = await WeatherApi.getWeatherForCity(
        location: Location(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
        useCelcius: ref.read(useCelciusProvider),
      );
      final newCity = City(
        location: location,
        weather: weatherData,
        uuid: const Uuid().v4(),
      );

      state = AsyncValue.data([
        ...cities,
        newCity,
      ]);
    } on ApiExeption catch (apiExeption) {
      logger.e("Got ApiExeption: ${apiExeption.toString()}");

      state = AsyncValue.error(apiExeption, StackTrace.current);
    } on UnknownApiExeption catch (unknownApiExeption) {
      logger.e("Got UnknownApiExeption: ${unknownApiExeption.toString()}");
      state = AsyncValue.error(unknownApiExeption, StackTrace.current);
    }
  }

  /// Remove a city from the list
  Future<void> removeCity(String uuid) async {
    // Get all cities
    final cities = state.value ?? [];

    // Remove from storage
    final prefsInstance = await SharedPreferences.getInstance();
    await prefsInstance.setStringList(
      citiesSharedPrefsKey,
      cities
          .where((city) => city.uuid != uuid)
          .map((city) => city.location.toJson())
          .toList(),
    );

    logger.i("Removed city from shared preferences");

    // Update the app state
    state = AsyncValue.data(
      cities.where((city) => city.uuid != uuid).map((city) => city).toList(),
    );
  }

  /// Toggle `useCelcius` and update the cities with the new weather data
  Future<void> toggleUseCelcius(bool useCelcius) async {
    // If `useCelcius` hasn't changed, ignore the update
    final bool useCelciusProviderValue = ref.read(useCelciusProvider);
    if (useCelcius == useCelciusProviderValue) {
      return;
    }

    // Update the variable
    ref.read(useCelciusProvider.notifier).state = useCelcius;

    // Update the storage
    final prefsInstance = await SharedPreferences.getInstance();
    await prefsInstance.setBool(useCelciusKey, useCelcius);

    logger.i("Updated useCelcius value");

    // Load the new weather data
    try {
      final oldUuids = (state.value ?? []).map((e) => e.uuid).toList();

      final locations = (state.value ?? []).map((e) => e.location).toList();
      final weatherData = await WeatherApi.getWeatherForCities(
        locations: locations
            .map(
              (location) => Location(
                latitude: location.latitude,
                longitude: location.longitude,
              ),
            )
            .toList(),
        useCelcius: useCelcius,
      );
      logger.i("Loaded new weather data for the cities");

      // Update the app state
      List<City> cities = [];
      for (int i = 0; i < locations.length; i++) {
        cities.add(
          City(
            location: locations[i],
            weather: weatherData[i],
            uuid: oldUuids[i],
          ),
        );
      }

      state = AsyncValue.data(cities);
    } on ApiExeption catch (apiExeption) {
      logger.e("Got ApiExeption: ${apiExeption.toString()}");

      state = AsyncValue.error(apiExeption, StackTrace.current);
    } on UnknownApiExeption catch (unknownApiExeption) {
      logger.e("Got UnknownApiExeption: ${unknownApiExeption.toString()}");
      state = AsyncValue.error(unknownApiExeption, StackTrace.current);
    }
  }
}

final citiesProvider = AsyncNotifierProvider<CitiesNotifier, List<City>>(
  () => CitiesNotifier(),
);

final useCelciusProvider = StateProvider<bool>((ref) => true);
