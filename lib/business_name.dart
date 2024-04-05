import 'dart:math';

import 'package:flutter/material.dart';

class BusinessName {
  bool isTextAdded = false;
  Offset textPosition = const Offset(0, 0);
  double textSize = 14.0;
  Color textColor = Colors.white; // Default text color
  final String fontName = 'Roboto';
  final String fontStyle = "normal";


  Offset getTextPosition(){
    return Offset(max(0, textPosition.dx), max(0, textPosition.dy));
  }
}

class Logo{
  Offset imagePosition;
  Size imageSize;

  Logo({required this.imagePosition, required this.imageSize});

  Offset getImagePosition(){
    return Offset(max(0, imagePosition.dx), max(0, imagePosition.dy));
  }
}
