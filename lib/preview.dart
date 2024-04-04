import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/config.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final Configuration config;
  final double containerWidth;
  final double containerHeight;


  const PreviewScreen({
    Key? key,
    required this.imageBytes,
    required this.config,
    required this.containerWidth,
    required this.containerHeight, // Default size is 200. Can also pass 350 when navigating
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculations are now fully dynamic based on configuration percentages
    double scaledFontSize = config.fontSizePercentage * 0.01 * containerWidth; // fontSizePercentage is a percentage
    double leftPosition = config.leftMarginPercentage * 0.01 * containerWidth; // Adjust according to margin percentages
    double topPosition = config.topMarginPercentage * 0.01 * containerHeight;

    // Handle potential hex color format issues (ensure your config.fontColor includes alpha if needed)
    final Color fontColor = Color(int.parse(config.fontColor.substring(1), radix: 16) | 0xFF000000);

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview $containerWidth x $containerHeight'),
      ),
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            image: DecorationImage(
              image: MemoryImage(imageBytes),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: leftPosition, // Ensure the text remains within bounds
                top: topPosition,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      config.textContent,
                      style: TextStyle(
                        fontSize: scaledFontSize,
                        color: fontColor,
                        fontFamily: config.fontName,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
