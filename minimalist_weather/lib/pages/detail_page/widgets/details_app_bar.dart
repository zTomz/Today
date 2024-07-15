import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';

class DetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool useCelcius;
  final void Function(bool useCelcius) toggleCelcius;

  const DetailsAppBar({
    super.key,
    required this.useCelcius,
    required this.toggleCelcius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: appBarHeight + MediaQuery.paddingOf(context).top,
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
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 28,
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                toggleCelcius(true);
              },
              icon: Text(
                "°C",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: useCelcius
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            IconButton(
              onPressed: () {
                toggleCelcius(false);
              },
              icon: Text(
                "°F",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: useCelcius
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
