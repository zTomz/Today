import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/cities_page/provider/cities_provider.dart';

class CitiesListView extends ConsumerWidget {
  const CitiesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCities = ref.watch(citiesProvider);

    return switch (asyncCities) {
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.large,
                vertical: Spacing.medium,
              ),
              decoration: BoxDecoration(
                border: index != value.length - 1 ? Border(
                  bottom:  BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: defaultBorderWidth,
                  ),
                ) : null,
              ),
              child: Row(
                children: [
                  Text(
                    value[index].location.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  // TODO: Display the weather of the city here
                  const Text("WEATER"),
                ],
              ),
            );
          },
        ),
      AsyncError(:final error) => Center(
          child: Text(
            error.toString(),
          ),
        ),
      _ => const Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}
