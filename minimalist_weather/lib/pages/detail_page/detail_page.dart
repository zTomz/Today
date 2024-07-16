import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/background_blob.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/big_weather_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/daily_detail_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/details_app_bar.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/hourly_forecast_section.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';

class DetailPage extends ConsumerWidget {
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

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const BackgroundBlob(),
          Column(
            children: [
              const DetailsAppBar(),
              Expanded(
                child: switch (asyncCity) {
                  AsyncData(:final value) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BigWeatherSection(city: value),
                        DailyDetailSection(city: value),
                        HourlyForecastSection(city: value),
                      ],
                    ),
                  _ => const Center(
                      child: CircularProgressIndicator(),
                    ),
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
