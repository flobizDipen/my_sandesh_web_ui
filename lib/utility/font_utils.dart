import 'package:flutter/material.dart';

class FontUtils {
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

  static const Map<FontWeight, String> fontWeightNames = {
    FontWeight.w100: '100 Thin',
    FontWeight.w200: '200 Extra Light',
    FontWeight.w300: '300 Light',
    FontWeight.w400: '400 Normal',
    FontWeight.w500: '500 Medium',
    FontWeight.w600: '600 Semi Bold',
    FontWeight.w700: '700 Bold',
    FontWeight.w800: '800 Extra Bold',
    FontWeight.w900: '900 Ultra Bold',
  };

  static FontWeight stringToFontWeight(String fontWeightString) {
    // Return the corresponding FontWeight, or FontWeight.normal as a default
    return _fontWeightMap[fontWeightString] ?? FontWeight.normal;
  }

  static Map<TextAlign, String> textAlignNames = {
    TextAlign.left: "Left",
    TextAlign.center: "Center",
    TextAlign.right: "Right",
    // Include any other alignments you wish to support
  };
}
