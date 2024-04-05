import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FontSupport {
  bool isTextAdded = false;
  Offset textPosition = const Offset(0, 0);
  double textSize = 14.0;
  Color textColor = Colors.white; // Default text color
  String fontFamily = 'Roboto';
  FontWeight fontWeight = FontWeight.normal;


  Offset getTextPosition(){
    return Offset(max(0, textPosition.dx), max(0, textPosition.dy));
  }
}

class Logo{
  Offset imagePosition = const Offset(0, 0);
  Size imageSize = const Size(100, 100);
  Uint8List? selectedLogo;

  Offset getImagePosition(){
    return Offset(max(0, imagePosition.dx), max(0, imagePosition.dy));
  }
}
