import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/component/text_field_type.dart';

class FontProperties {
  double textSize;
  FontWeight fontWeight;
  Color textColor;
  String fontFamily;
  Offset textPosition;

  FontProperties({
    this.textSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.fontFamily = 'Roboto',
    this.textPosition = const Offset(0, 0),
  });

  Offset getTextPosition() {
    return Offset(max(0, textPosition.dx), max(0, textPosition.dy));
  }
}

class TextElement {
  TextFieldType type;
  String buttonText;
  TextEditingController controller;
  FontProperties fontProperties;
  bool isAdded;

  TextElement({
    required this.type,
    required this.buttonText,
    required this.controller,
    required this.fontProperties,
    this.isAdded = false,
  });
}
