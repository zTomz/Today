import 'package:flutter/material.dart';
import 'package:today/pages/cities_page/widgets/cities_app_bar.dart';
import 'package:today/pages/cities_page/widgets/cities_list_view.dart';

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
