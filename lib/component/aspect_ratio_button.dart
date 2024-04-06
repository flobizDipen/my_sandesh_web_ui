import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';

class AspectRatioButtons extends StatelessWidget {
  final AspectRatioOption selectedAspectRatio;
  final Function(AspectRatioOption) onAspectRatioSelected;

  const AspectRatioButtons({
    super.key,
    required this.selectedAspectRatio,
    required this.onAspectRatioSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Gap between chips
      children: AspectRatioOption.values.map((aspectRatio) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: customChoiceChip(
            aspectRatio.name,
            selectedAspectRatio == aspectRatio,
            (selected) => onAspectRatioSelected(aspectRatio),
          ),
        );
      }).toList(),
    );
  }

  Widget customChoiceChip(String label, bool selected, Function(bool selected) onSelected) {
    return Container(
      decoration: BoxDecoration(
        color: MSColors.actionBar, // Background color
        border: Border.all(
          color: selected ? Colors.blueAccent : MSColors.surfaceColor, // Border color
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: ChoiceChip(
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: MSColors.surfaceColor, // Text color
          ),
        ),
        selected: selected,
        onSelected: onSelected,
        backgroundColor: MSColors.actionBar,
        selectedColor: MSColors.actionBar,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
    );
  }
}
