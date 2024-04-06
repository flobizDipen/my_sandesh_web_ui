import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        surfaceTintColor: MSColors.actionBar,
        backgroundColor: MSColors.actionBar,
        foregroundColor: MSColors.surfaceColor,
        // Adjust according to your theme
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        side: const BorderSide(color: MSColors.surfaceColor, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: widget.onPressed,
      child: Text(widget.label),
    );
  }
}
