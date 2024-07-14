import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/config/constants.dart';
import 'package:minimalist_weather/pages/cities_page/provider/cities_provider.dart';
import 'package:minimalist_weather/widgets/custom_button.dart';

class NewCityDialog extends HookConsumerWidget {
  const NewCityDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newCityController = useTextEditingController();

    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(defaultBorderRadius),
        ),
      ),
      backgroundColor: Colors.white,
      title: const Text("Add a new city"),
      contentPadding: const EdgeInsets.all(
        Spacing.medium,
      ),
      children: [
        TextField(
          controller: newCityController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            hintText: "City name",
          ),
        ),
        const SizedBox(height: Spacing.medium),
        Row(
          children: [
            Expanded(
              child: CustomButton.outlined(
                text: "Close",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: Spacing.medium),
            Expanded(
              flex: 2,
              child: CustomButton(
                text: "Add",
                onPressed: () async {
                  // Check the controller
                  if (newCityController.text.trim().length <= 1) {
                    // TODO: Show a snackbar, that the city name is too short
                    return;
                  }

                  // Add the city
                  await ref
                      .read<CitiesNotifier>(citiesProvider.notifier)
                      .addCity(
                        newCityController.text.trim(),
                      );

                  // Close the dialog
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
