import 'package:flutter/material.dart';

class FontWeightUtils {
  static const Map<String, FontWeight> _fontWeightMap = {
    'normal': FontWeight.normal,
    'bold': FontWeight.bold,
    '100': FontWeight.w100,
    '200': FontWeight.w200,
    '300': FontWeight.w300,
    '400': FontWeight.w400, // same as normal
    '500': FontWeight.w500,
    '600': FontWeight.w600,
    '700': FontWeight.w700, // same as bold
    '800': FontWeight.w800,
    '900': FontWeight.w900,
  };

  static FontWeight stringToFontWeight(String fontWeightString) {
    // Return the corresponding FontWeight, or FontWeight.normal as a default
    return _fontWeightMap[fontWeightString] ?? FontWeight.normal;
  }
}