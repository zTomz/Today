import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/detail_page/detail_page.dart';
import 'package:minimalist_weather/provider/city.dart';

class CityListTile extends HookWidget {
  final City city;
  final bool hasBorder;

  const CityListTile({
    super.key,
    required this.city,
    required this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    final isTapDown = useState<bool>(false);

    return GestureDetector(
      onTapDown: (_) async {
        if (isTapDown.value) return;

        isTapDown.value = true;

        await Future.delayed(AnimationDurations.animation, () {
          isTapDown.value = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailPage(
                cityUuid: city.uuid,
              ),
            ),
          );
        });
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
                      child: city.weather.hourlyWeatherData[DateTime.now().hour]
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
  }
}
