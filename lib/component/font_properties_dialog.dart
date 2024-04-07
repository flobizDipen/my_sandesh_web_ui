import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/component/text_color_picker.dart';
import 'package:my_sandesh_web_ui/model/text_element.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';
import 'package:my_sandesh_web_ui/utility/font_utils.dart';
import 'package:my_sandesh_web_ui/utility/widget_extension.dart';

class TextStyleOption extends StatefulWidget {
  final TextElement element;
  final Function(String) onTextUpdate;
  final Function(FontWeight) onFontWeight;
  final Function(double) onTextSize;
  final Function(Color) onColorChange;
  final Function(String) onFontFamily;
  final Function(TextAlign) onTextAlign;
  final Function(TextElement) onRemove;

  const TextStyleOption({
    super.key,
    required this.element,
    required this.onTextUpdate,
    required this.onFontWeight,
    required this.onTextSize,
    required this.onColorChange,
    required this.onFontFamily,
    required this.onTextAlign,
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
            context.divider(),
            const Text(
              "Font Color",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextColorPicker(initialColor: widget.element.fontProperties.textColor, onColorChange: changeColor),
            context.divider(),
            const Text(
              "Font Size",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
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
            context.divider(),
            const Text(
              "Text Alignment",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            DropdownButton<TextAlign>(
              value: widget.element.fontProperties.textAlign,
              onChanged: (TextAlign? newValue) {
                setState(() {
                  if (newValue != null) {
                    widget.element.fontProperties.textAlign = newValue;
                    widget.onTextAlign(newValue);
                  }
                });
              },
              items: FontUtils.textAlignNames.entries.map((entry) {
                return DropdownMenuItem<TextAlign>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            context.divider(),
            const Text(
              "Font Weight",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            DropdownButton<FontWeight>(
              value: widget.element.fontProperties.fontWeight,
              items: FontUtils.fontWeightNames.entries.map((entry) {
                return DropdownMenuItem<FontWeight>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  widget.element.fontProperties.fontWeight = value!;
                });
                widget.onFontWeight(value!);
              },
            ),
            context.divider(),
            const Text(
              "Font Family",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            context.divider(height: 10),
            _buildFontFamilyChips()
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

  Widget _buildFontFamilyChips() {
    List<String> fontFamilies = ['Roboto', 'Open Sans', 'Lato', 'Montserrat']; // Define your font families here

    return Wrap(
      spacing: 8.0,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: fontFamilies.map((String font) {
        return ChoiceChip(
          label: Text(font,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: MSColors.actionBar, // Text color
              )),
          selected: widget.element.fontProperties.fontFamily == font,
          backgroundColor: Colors.white60,
          selectedColor: Colors.blueAccent,
          showCheckmark: false,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          padding: const EdgeInsets.all(8),
          shape: StadiumBorder(
            side: BorderSide(
              color: widget.element.fontProperties.fontFamily == font ? Colors.blueAccent.shade400 : Colors.white60,
              // Change border color based on selection
              width: 1,
            ),
          ),
          onSelected: (bool selected) {
            setState(() {
              // Update font family when a chip is selected
              widget.element.fontProperties.fontFamily = font;
              widget.onFontFamily(font); // Notify the parent widget of the change
            });
          },
        );
      }).toList(),
    );
  }
}
