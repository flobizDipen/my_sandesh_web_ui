import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class Logo{
  Offset imagePosition = const Offset(0, 0);
  Size imageSize = const Size(100, 100);
  Uint8List? selectedLogo;

  Offset getImagePosition(){
    return Offset(max(0, imagePosition.dx), max(0, imagePosition.dy));
  }
}
