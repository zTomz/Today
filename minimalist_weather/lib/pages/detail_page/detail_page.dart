import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/background_blob.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/big_weather_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/daily_detail_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/details_app_bar.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/hourly_forecast_section.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DetailPage extends HookConsumerWidget {
  final String cityUuid;

  DetailPage({
    super.key,
    required this.cityUuid,
  });

  final GlobalKey _visibilityKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCity = ref.watch(citiesProvider).whenData(
          (cities) => cities.firstWhere((city) => city.uuid == cityUuid),
        );
    final isShown = useState<bool>(false);

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (isShown.value) return;

        logger.d("Show detail page");
        isShown.value = true;
      },
      child: Scaffold(
        body: asyncCity.when(
          data: (city) => Stack(
            alignment: Alignment.topCenter,
            children: [
              BackgroundBlob(
                color: city.weather.currentHourlyWeatherData.weatherColor,
              ),
              AnimatedOpacity(
                opacity: isShown.value ? 1.0 : 0.0,
                duration: AnimationDurations.animation,
                curve: Curves.easeIn,
                child: Column(
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
      ),
    );
  }
}
