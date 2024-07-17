import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/detail_page/detail_page.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';

class CitiesListView extends ConsumerWidget {
  const CitiesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCities = ref.watch(citiesProvider);

    return asyncCities.when(
      data: (cities) => ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];

          return GestureDetector(
            onTap: () {
              // TODO: Add animation

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    cityUuid: city.uuid,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(Spacing.large),
              decoration: BoxDecoration(
                border: index != cities.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: defaultBorderWidth,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${city.location.countryCode}, ${city.location.latitude}, ${city.location.longitude}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      Text(
                        city.location.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${city.location.timezoneTimeString} Uhr",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${city.weather.hourlyWeatherData[DateTime.now().hour].temperature2m}°",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(width: Spacing.small),
                          IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            child: city
                                .weather
                                .hourlyWeatherData[DateTime.now().hour]
                                .weatherIcon,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      error: (_, __) => const Center(
        child: Text(
          "Failed to load weather data",
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
