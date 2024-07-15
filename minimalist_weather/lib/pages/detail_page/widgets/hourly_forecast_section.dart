import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/provider/city.dart';

class HourlyForecastSection extends StatelessWidget {
  final City city;

  const HourlyForecastSection({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.large,
          vertical: Spacing.extraLarge,
        ),
        child: ListView.builder(
          itemCount:
              city.weather.hourlyWeatherData.length - DateTime.now().hour,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final hour =
                city.weather.hourlyWeatherData[DateTime.now().hour + index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${hour.time.hour}:00",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: Spacing.small),
                  Text(
                    "${hour.temperature2m.toInt()}°",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
