import 'package:flutter/material.dart';

class BlockPicker extends StatelessWidget {
  final Color pickerColor;
  final Function(Color) onColorChanged;

  const BlockPicker({Key? key, required this.pickerColor, required this.onColorChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a list of colors to pick from
    final List<Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.white, Colors.purple, Colors.black];

    return Wrap(
      children: _colors.map((Color color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            margin: const EdgeInsets.all(5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }
}
