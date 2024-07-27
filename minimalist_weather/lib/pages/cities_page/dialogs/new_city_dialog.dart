import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minimalist_weather/core/apis/geocoding_api.dart';
import 'package:minimalist_weather/core/config/constants.dart';
import 'package:minimalist_weather/core/exeptions/cities_provider_exeptions.dart';
import 'package:minimalist_weather/core/services/vibration_service.dart';
import 'package:minimalist_weather/provider/cities_provider.dart';
import 'package:minimalist_weather/widgets/custom_button.dart';

class NewCityDialog extends HookConsumerWidget {
  const NewCityDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = useState<String?>(null);
    final geoLocation = useState<GeoLocation?>(null);

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
        Autocomplete<GeoLocation>(
          optionsBuilder: (value) async {
            List<GeoLocation> results = [];
            error.value = null;

            try {
              results = await GeocodingApi.getSuggestions(
                value.text,
              );
            } catch (e) {
              error.value = e.toString();
            }

            return results;
          },
          onSelected: (value) {
            geoLocation.value = value;
          },
          displayStringForOption: (option) {
            return "${option.name}, ${option.countryCode}";
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onSubmitted: (_) => onFieldSubmitted,
              enableSuggestions: true,
              decoration: InputDecoration(
                error:
                    error.value != null ? Text("Error: ${error.value}") : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(defaultBorderRadius),
                  ),
                ),
                hintText: "City name",
              ),
            );
          },
        ),
        const SizedBox(height: Spacing.medium),
        Row(
          children: [
            Expanded(
              child: CustomButton.outlined(
                label: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: Spacing.medium),
            Expanded(
              flex: 2,
              child: CustomButton(
                label: const Text("Add"),
                onPressed: () async {
                  // Check the controller
                  if (geoLocation.value == null) {
                    error.value = "No city selected";
                    VibrationService().warning();

                    return;
                  }

                  // Add the city
                  try {
                    await ref
                        .read<CitiesNotifier>(citiesProvider.notifier)
                        .addCity(
                          geoLocation.value!,
                        );
                  } on CityAlreadyExistsExeption catch (e) {
                    error.value = e.message;
                    VibrationService().warning();
                    return;
                  } catch (e) {
                    rethrow;
                  }

                  VibrationService().success();

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
