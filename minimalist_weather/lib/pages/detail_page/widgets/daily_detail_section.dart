import 'package:flutter/material.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/provider/city.dart';

class DailyDetailSection extends StatelessWidget {
  final City city;

  const DailyDetailSection({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.extraLarge),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: defaultBorderWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DetailSection(
            temperature: city
                .weather.dailyWeatherData.first.apparentTemperatureMax
                .toInt(),
            isMax: true,
            label1: "humidity",
            label2: "uv index",
            value1: "${city.weather.currentHourlyWeatherData.relativeHumidity2m}%",
            value2: city.weather.dailyWeatherData.first.uvIndexMax.toString(),
          ),
           _DetailSection(
            temperature: city
                .weather.dailyWeatherData.first.apparentTemperatureMin
                .toInt(),
            isMax: false,
            label1: "wind",
            label2: "pressure",
            value1: "${city.weather.currentHourlyWeatherData.windSpeed10m} ${city.weather.currentHourlyWeatherData.windSpeed10mUnit}",
            value2: "${city.weather.currentHourlyWeatherData.surfacePressure} ${city.weather.currentHourlyWeatherData.surfacePressureUnit}",
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final int temperature;
  final bool isMax;
  final String label1;
  final String label2;
  final String value1;
  final String value2;

  const _DetailSection({
    required this.temperature,
    required this.isMax,
    required this.label1,
    required this.label2,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isMax ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            ),
            const SizedBox(width: Spacing.small),
            Text(
              "$temperature°",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
        const SizedBox(height: Spacing.large),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: Spacing.large),
                Text(
                  label2,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(width: Spacing.medium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: Spacing.large),
                Text(
                  value2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
