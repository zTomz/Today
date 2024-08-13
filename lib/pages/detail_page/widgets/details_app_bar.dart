import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:today/core/config/constants.dart';
import 'package:today/core/services/vibration_service.dart';
import 'package:today/provider/cities_provider.dart';

class DetailsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DetailsAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCelcius = ref.watch(useCelciusProvider);

    return Container(
      alignment: Alignment.center,
      height: defaultAppBarHeight + MediaQuery.paddingOf(context).top,
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
                VibrationService().vibrate();
                Navigator.of(context).pop();
              },
              iconSize: 28,
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                VibrationService().selection();
                await ref.read(citiesProvider.notifier).toggleUseCelcius(true);
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
              onPressed: () async {
                VibrationService().selection();
                await ref.read(citiesProvider.notifier).toggleUseCelcius(false);
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
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);
}
