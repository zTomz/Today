import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/core/services/vibration_service.dart';
import 'package:minimalist_weather/pages/cities_page/dialogs/new_city_dialog.dart';
import 'package:minimalist_weather/pages/cities_page/widgets/city_list_tile.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';
import 'package:minimalist_weather/widgets/custom_button.dart';

class CitiesListView extends HookConsumerWidget {
  const CitiesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCities = ref.watch(citiesProvider);

    return asyncCities.when(
      data: (cities) {
        if (cities.isEmpty) {
          return Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: CustomButton.outlined(
                label: Text(
                  "Add your first city",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                icon: const Icon(Icons.add_rounded),
                onPressed: () async {
                  VibrationService().vibrate();
                  await showDialog(
                    context: context,
                    builder: (context) => const NewCityDialog(),
                  );
                },
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return CityListTile(
              city: cities[index],
              hasBorder: index != cities.length - 1,
            )
                .animate(
                  delay: AnimationDurations.getDelayDuration(index),
                )
                .fadeIn(
                  duration: AnimationDurations.animation,
                  curve: Curves.easeIn,
                )
                .slideY(
                  duration: AnimationDurations.animation,
                  curve: Curves.easeIn,
                );
          },
        );
      },
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
