import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/pages/cities_page/provider/cities_provider.dart';
import 'package:minimalist_weather/pages/cities_page/widgets/cities_app_bar.dart';

class CitiesPage extends ConsumerWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);

    return const Scaffold(
      appBar: CitiesAppBar(),
    );
  }
}
