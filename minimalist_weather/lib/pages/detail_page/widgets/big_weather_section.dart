import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/provider/city.dart';

class BigWeatherSection extends StatelessWidget {
  final City city;

  const BigWeatherSection({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.large,
        vertical: Spacing.extraLarge - Spacing.medium * 1.2,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: defaultBorderWidth,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: Spacing.extraLarge),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              city.location.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          SizedBox(
            height: 170,
            child: Hero(
              tag: "weather_${city.uuid}",
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${city.weather.currentTemperature.toInt()}",
                      style: TextStyle(
                        fontSize: 160,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: Spacing.medium),
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.medium),
                      child: IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        child: city.weather
                            .hourlyWeatherData[DateTime.now().hour].weatherIcon,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: Spacing.large * 1.2),
                        Text(
                          city.weather.currentHourlyWeatherData
                              .weatherDescription
                              .toLowerCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "feels like ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                              ),
                              TextSpan(
                                text:
                                    "${city.weather.hourlyWeatherData[DateTime.now().hour].apparentTemperature.toInt()}°",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.medium * 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
