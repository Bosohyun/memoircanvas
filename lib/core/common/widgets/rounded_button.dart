import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    this.buttonColor,
    this.labelColor,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? context.theme.colorScheme.primary,
        foregroundColor: labelColor ?? Colors.white,
        elevation: 6,
        minimumSize: const Size(double.maxFinite, 50),
      ),
      onPressed: onPressed,
      child: AutoSizeText(
        label,
      ),
    );
  }
}
