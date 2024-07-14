import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/cities_page/dialogs/new_city_dialog.dart';

class CitiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CitiesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.large,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: defaultBorderWidth,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "today",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            IconButton(
              onPressed: () async {
                // TODO: Add a new city

                await showDialog(
                  context: context,
                  builder: (context) => const NewCityDialog(),
                );
              },
              iconSize: 28,
              icon: const Icon(
                Icons.add_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}
