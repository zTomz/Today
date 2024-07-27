import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/core/services/vibration_service.dart';
import 'package:minimalist_weather/pages/detail_page/detail_page.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';
import 'package:minimalist_weather/provider/city.dart';

class CityListTile extends HookConsumerWidget {
  final City city;
  final bool hasBorder;

  CityListTile({
    super.key,
    required this.city,
    required this.hasBorder,
  });

  final GlobalKey _dismissKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapDown = useState<bool>(false);

    return Dismissible(
      key: _dismissKey,
      onDismissed: (direction) {
        ref.read(citiesProvider.notifier).removeCity(city.uuid);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.center,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      child: GestureDetector(
        onPanDown: (_) {
          if (isTapDown.value) return;

          isTapDown.value = true;
        },
        onPanCancel: () {
          isTapDown.value = false;
        },
        onTapUp: (_) {
          VibrationService().vibrate();

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
            border: hasBorder
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
              AnimatedScale(
                duration: AnimationDurations.animation,
                curve: Curves.easeInOut,
                scale: isTapDown.value ? 0.75 : 1,
                child: Column(
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
                  Hero(
                    tag: "weather_${city.uuid}",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${city.weather.currentTemperature.toInt()}°",
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
