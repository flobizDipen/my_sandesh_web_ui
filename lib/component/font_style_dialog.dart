import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/block_picker.dart';

class FontProperties {
  bool isTextAdded = false;
  Offset textPosition = const Offset(0, 0);
  double textSize = 14.0;
  Color textColor = Colors.white; // Default text color
  String fontFamily = 'Roboto';
  FontWeight fontWeight = FontWeight.normal;

  Offset getTextPosition() {
    return Offset(max(0, textPosition.dx), max(0, textPosition.dy));
  }
}

void showTextOptionsDialog({
  required BuildContext context,
  required TextEditingController controller,
  required FontProperties fontStyle,
  required Function(String) onTextUpdate,
  required Function(FontWeight) onFontWeight,
  required Function(double) onTextSize,
  required Function(Color) onColorChange,
  required Function(String) onFontFamily,
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
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Input Text',
                    ),
                    onChanged: (value) {
                      onTextUpdate(value);
                    },
                  ),
                  const Divider(),
                  BlockPicker(
                    pickerColor: fontStyle.textColor, // Use current text color
                    onColorChanged: (color) {
                      setState(() {
                        fontStyle.textColor = color;
                      });
                      onColorChange(color);
                    },
                  ),
                  const Divider(),
                  Slider(
                    min: 14,
                    max: 50,
                    divisions: 36,
                    value: fontStyle.textSize,
                    label: fontStyle.textSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        fontStyle.textSize = value;
                      });
                      onTextSize(value);
                    },
                  ),
                  const Divider(),
                  DropdownButton<FontWeight>(
                    value: fontStyle.fontWeight,
                    items: FontWeight.values.map((FontWeight value) {
                      return DropdownMenuItem<FontWeight>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        fontStyle.fontWeight = value!;
                      });
                      onFontWeight(value!);
                    },
                  ),
                  const Divider(),
                  DropdownButton<String>(
                    value: fontStyle.fontFamily,
                    items: <String>['Roboto', 'Open Sans', 'Lato', 'Montserrat'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        fontStyle.fontFamily = value!;
                      });
                      onFontFamily(value!);
                    },
                  )
                ],
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
  );
}
