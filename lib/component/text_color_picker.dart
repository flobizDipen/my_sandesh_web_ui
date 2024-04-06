import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TextColorPicker extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorChange;

  const TextColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChange,
  });

  @override
  _TextColorPickerState createState() => _TextColorPickerState();
}

class _TextColorPickerState extends State<TextColorPicker> {
  late TextEditingController colorController;
  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    colorController = TextEditingController(text: '#${widget.initialColor.value.toRadixString(16).substring(2)}');
    selectedColor = widget.initialColor;
  }

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  Color? _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.toUpperCase().replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return null; // Return null if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          width: 24,
          // Square width
          height: 24,
          // Square height
          margin: const EdgeInsets.only(right: 8),
          // Add some space between the square and the TextField
          decoration: BoxDecoration(
            color: selectedColor ?? widget.initialColor, // Use the selected color
            border: Border.all(color: Colors.black.withOpacity(0.5)), // Optional: add a border
          ),
        ),
        Flexible(
          child: TextField(
            controller: colorController,
            decoration: const InputDecoration(labelText: 'Color Hex'),
            maxLength: 9,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^#[0-9a-fA-F]{0,8}$'))],
            onChanged: (value) {
              final Color? color = _getColorFromHex(value);
              if (color != null) {
                setState(() {
                  selectedColor = color; // Update the selected color
                });
                widget.onColorChange(color);
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.color_lens),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: _getColorFromHex(colorController.text) ?? Colors.white,
                      onColorChanged: (Color color) {
                        setState(() {
                          colorController.text = '#${color.value.toRadixString(16).substring(2)}';
                          selectedColor = color;
                        });
                        widget.onColorChange(color);
                      },
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
