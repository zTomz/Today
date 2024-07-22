import 'package:flutter/material.dart';
import 'package:minimalist_weather/config/constants.dart';

class CustomButton extends StatelessWidget {
  final _CustomButtonVariant _variant;

  final Widget label;
  final Icon? icon;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  }) : _variant = _CustomButtonVariant.filled;

  const CustomButton.outlined({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  }) : _variant = _CustomButtonVariant.outlined;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.small),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadius),
          ),
        ),
        backgroundColor: _variant == _CustomButtonVariant.filled
            ? Theme.of(context).colorScheme.onSurface
            : Colors.transparent,
        foregroundColor: _variant == _CustomButtonVariant.filled
            ? Colors.white
            : Colors.black,
        side: _variant == _CustomButtonVariant.outlined
            ? BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: defaultBorderWidth,
              )
            : null,
      ),
      label: label,
      icon: icon,
    );
  }
}

enum _CustomButtonVariant {
  filled,
  outlined,
}
