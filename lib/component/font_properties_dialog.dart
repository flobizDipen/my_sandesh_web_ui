import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/component/text_color_picker.dart';
import 'package:my_sandesh_web_ui/model/text_element.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';

class TextStyleOption extends StatefulWidget {
  final TextElement element;
  final Function(String) onTextUpdate;
  final Function(FontWeight) onFontWeight;
  final Function(double) onTextSize;
  final Function(Color) onColorChange;
  final Function(String) onFontFamily;
  final Function(TextElement) onRemove;

  const TextStyleOption({
    super.key,
    required this.element,
    required this.onTextUpdate,
    required this.onFontWeight,
    required this.onTextSize,
    required this.onColorChange,
    required this.onFontFamily,
    required this.onRemove,
  });

  @override
  State<TextStyleOption> createState() => _TextStyleOptionState();
}

class _TextStyleOptionState extends State<TextStyleOption> {
  late TextEditingController colorController;

  @override
  void initState() {
    super.initState();
    colorController =
        TextEditingController(text: '#${widget.element.fontProperties.textColor.value.toRadixString(16).substring(2)}');
  }

  @override
  void dispose() {
    colorController.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    widget.onColorChange(color);
    colorController.text = '#${color.value.toRadixString(16).substring(2)}';
  }

  @override
  Widget build(BuildContext context) {

    // Determine the dialog width
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;

    return AlertDialog(
      title: const Text('Text Options'),
      content: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: widget.element.controller,
              decoration: const InputDecoration(
                labelText: 'Input Text',
              ),
              onChanged: (value) {
                widget.onTextUpdate(value);
              },
            ),
            const Divider(),
            TextColorPicker(initialColor: widget.element.fontProperties.textColor, onColorChange: changeColor),
            const Divider(),
            Slider(
              min: 8,
              max: 50,
              divisions: 42,
              value: widget.element.fontProperties.textSize,
              label: widget.element.fontProperties.textSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  widget.element.fontProperties.textSize = value;
                });
                widget.onTextSize(value);
              },
            ),
            const Divider(),
            DropdownButton<FontWeight>(
              value: widget.element.fontProperties.fontWeight,
              items: FontWeight.values.map((FontWeight value) {
                return DropdownMenuItem<FontWeight>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  widget.element.fontProperties.fontWeight = value!;
                });
                widget.onFontWeight(value!);
              },
            ),
            const Divider(),
            DropdownButton<String>(
              value: widget.element.fontProperties.fontFamily,
              items: <String>['Roboto', 'Open Sans', 'Lato', 'Montserrat'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  widget.element.fontProperties.fontFamily = value!;
                });
                widget.onFontFamily(value!);
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        if (widget.element.isAdded) // Conditionally add the Delete button
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              widget.onRemove(widget.element);
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        TextButton(
          child: const Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
