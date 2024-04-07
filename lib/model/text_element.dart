import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/component/text_field_type.dart';
import 'package:my_sandesh_web_ui/theme/ms_colors.dart';

class FontProperties {
  double textSize;
  FontWeight fontWeight;
  Color textColor;
  String fontFamily;
  Offset textPosition;
  TextAlign textAlign;

  FontProperties({
    this.textSize = 20.0,
    this.fontWeight = FontWeight.normal,
    this.textColor = MSColors.neutralWhite,
    this.fontFamily = 'Roboto',
    this.textPosition = const Offset(20, 20),
    this.textAlign = TextAlign.left,
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
