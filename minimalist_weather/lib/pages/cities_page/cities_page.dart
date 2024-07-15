import 'package:flutter/material.dart';
import 'package:minimalist_weather/pages/cities_page/widgets/cities_app_bar.dart';
import 'package:minimalist_weather/pages/cities_page/widgets/cities_list_view.dart';

class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CitiesAppBar(),
      body: CitiesListView(),
    );
  }
}
