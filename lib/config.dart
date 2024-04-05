import 'package:flutter/material.dart';

class Configuration {
  final double containerWidth;
  final double containerHeight;
  final double topMarginPercentage;
  final double leftMarginPercentage;
  final String fontStyle;
  final String fontName;
  final double fontSizePercentage;
  final String fontColor;
  final String textContent;
  final double additionalImageLeftPercentage;
  final double additionalImageTopPercentage;
  final double additionalImageSizeWidthPercentage;
  final double additionalImageSizeHeightPercentage;

  Configuration(
      {required this.containerWidth,
      required this.containerHeight,
      required this.topMarginPercentage,
      required this.leftMarginPercentage,
      required this.fontStyle,
      required this.fontName,
      required this.fontSizePercentage,
      required this.fontColor,
      required this.textContent,
      required this.additionalImageLeftPercentage,
      required this.additionalImageTopPercentage,
      required this.additionalImageSizeWidthPercentage,
      required this.additionalImageSizeHeightPercentage});

  Map<String, dynamic> toJson() {
    return {
      "aspectRatio": "1:1",
      "elements": {
        "businessName": {
          "fontStyle": fontStyle,
          "fontName": fontName,
          "fontSize": fontSizePercentage,
          "fontColor": fontColor,
          "positioning": {
            "top": topMarginPercentage,
            "left": leftMarginPercentage,
          }
        },
        "additionalImage": {
          "position": {
            "left": additionalImageLeftPercentage,
            "top": additionalImageTopPercentage,
          },
          "size": {"width": additionalImageSizeWidthPercentage, "height": additionalImageSizeHeightPercentage}, // Assuming fixed size for simplicity
        }
      }
    };
  }
}

Configuration createConfiguration({
  required double containerWidth,
  required double containerHeight,
  required Offset textPosition,
  required Offset imagePosition,
  required Size imageSize,
  required String fontStyle,
  required String fontName,
  required double fontSize,
  required Color fontColor,
  required String textContent,
}) {
  // Convert the fontColor to a hex string properly
  String fontColorHex = '#${fontColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (fontSize / containerWidth) * 100;

  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  final additionalImageLeftPercentage = imagePosition.dx / containerWidth * 100;
  final additionalImageTopPercentage = imagePosition.dy / containerHeight * 100;

  // Convert imageSize to percentages of the container's dimensions
  final additionalImageWidthPercentage = (imageSize.width / containerWidth) * 100;
  final additionalImageHeightPercentage = (imageSize.height / containerHeight) * 100;

  return Configuration(
      containerWidth: containerWidth,
      containerHeight: containerHeight,
      topMarginPercentage: topMarginPercentage,
      leftMarginPercentage: leftMarginPercentage,
      fontStyle: fontStyle,
      fontName: fontName,
      fontSizePercentage: fontSizePercentage,
      fontColor: fontColorHex,
      textContent: textContent,
      additionalImageLeftPercentage: additionalImageLeftPercentage,
      additionalImageTopPercentage: additionalImageTopPercentage,
      additionalImageSizeWidthPercentage: additionalImageWidthPercentage,
      additionalImageSizeHeightPercentage: additionalImageHeightPercentage);
}
