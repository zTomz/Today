import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/background_blob.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/big_weather_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/daily_detail_section.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/details_app_bar.dart';
import 'package:minimalist_weather/pages/detail_page/widgets/hourly_forecast_section.dart';
import 'package:minimalist_weather/provider/city.dart';

class DetailPage extends HookWidget {
  final City city;

  const DetailPage({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    final useCelcius = useState<bool>(true);

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const BackgroundBlob(),
          Column(
            children: [
              DetailsAppBar(
                useCelcius: useCelcius.value,
                toggleCelcius: (value) {
                  useCelcius.value = value;
                },
              ),
              // TODO: Use the use celcius hook, and convert the temperature to the other unit
              BigWeatherSection(city: city),
              DailyDetailSection(city: city),
              HourlyForecastSection(city: city),
            ],
          ),
        ],
      ),
    );
  }
}
