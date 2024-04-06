import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/block_picker.dart';
import 'package:my_sandesh_web_ui/component/text_element.dart';

void showTextOptionsDialog({
  required BuildContext context,
  required TextElement element,
  required Function(String) onTextUpdate,
  required Function(FontWeight) onFontWeight,
  required Function(double) onTextSize,
  required Function(Color) onColorChange,
  required Function(String) onFontFamily,
  required Function(TextElement) onRemove,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // Use StatefulBuilder to manage state inside the dialog
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Text Options'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: element.controller,
                    decoration: const InputDecoration(
                      labelText: 'Input Text',
                    ),
                    onChanged: (value) {
                      onTextUpdate(value);
                    },
                  ),
                  const Divider(),
                  BlockPicker(
                    pickerColor: element.fontProperties.textColor, // Use current text color
                    onColorChanged: (color) {
                      setState(() {
                        element.fontProperties.textColor = color;
                      });
                      onColorChange(color);
                    },
                  ),
                  const Divider(),
                  Slider(
                    min: 8,
                    max: 50,
                    divisions: 42,
                    value: element.fontProperties.textSize,
                    label: element.fontProperties.textSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        element.fontProperties.textSize = value;
                      });
                      onTextSize(value);
                    },
                  ),
                  const Divider(),
                  DropdownButton<FontWeight>(
                    value: element.fontProperties.fontWeight,
                    items: FontWeight.values.map((FontWeight value) {
                      return DropdownMenuItem<FontWeight>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        element.fontProperties.fontWeight = value!;
                      });
                      onFontWeight(value!);
                    },
                  ),
                  const Divider(),
                  DropdownButton<String>(
                    value: element.fontProperties.fontFamily,
                    items: <String>['Roboto', 'Open Sans', 'Lato', 'Montserrat'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        element.fontProperties.fontFamily = value!;
                      });
                      onFontFamily(value!);
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              if (element.isAdded) // Conditionally add the Delete button
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    // Call the function to delete the text field
                    onRemove(element);
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
        },
      );
    },
  );
}
