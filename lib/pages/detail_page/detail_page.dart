import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:today/widgets/background_blob.dart';
import 'package:today/pages/detail_page/widgets/big_weather_section.dart';
import 'package:today/pages/detail_page/widgets/daily_detail_section.dart';
import 'package:today/pages/detail_page/widgets/details_app_bar.dart';
import 'package:today/pages/detail_page/widgets/hourly_forecast_section.dart';
import 'package:today/provider/cities_provider.dart';

class DetailPage extends HookConsumerWidget {
  final String cityUuid;

  const DetailPage({
    super.key,
    required this.cityUuid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCity = ref.watch(citiesProvider).whenData(
          (cities) => cities.firstWhere((city) => city.uuid == cityUuid),
        );
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: asyncCity.when(
        data: (city) => Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -screenSize.width * 0.9,
              left: -screenSize.width / 2,
              child: BackgroundBlob(
                color: city.weather.currentHourlyWeatherData.weatherColor,
                size: Size.square(
                  screenSize.width * 2,
                ),
              ),
            ),
            Column(
              children: [
                const DetailsAppBar(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BigWeatherSection(city: city),
                      DailyDetailSection(city: city),
                      HourlyForecastSection(city: city),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        error: (_, __) => const Center(
          child: Text(
            "Failed to load weather data",
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
