import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/config.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final Configuration config;
  final double containerSize;

  const PreviewScreen({
    Key? key,
    required this.imageBytes,
    required this.config,
    this.containerSize = 200.0, // Default size is 200. Can also pass 350 when navigating
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculations are now fully dynamic based on configuration percentages
    double scaledFontSize = config.fontSizePercentage * 0.01 * containerSize; // fontSizePercentage is a percentage
    double leftPosition = config.leftMarginPercentage * 0.01 * containerSize; // Adjust according to margin percentages
    double topPosition = config.topMarginPercentage * 0.01 * containerSize;

    // Handle potential hex color format issues (ensure your config.fontColor includes alpha if needed)
    final Color fontColor = Color(int.parse(config.fontColor.substring(1), radix: 16) | 0xFF000000);

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview $containerSize x $containerSize'),
      ),
      body: Center(
        child: Container(
          width: containerSize,
          height: containerSize,
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
            ],
          ),
        ),
      ),
    );
  }
}
