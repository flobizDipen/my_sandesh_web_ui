import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/config.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List frame;
  final Uint8List image;
  final Configuration config;
  final double containerWidth;
  final double containerHeight;

  const PreviewScreen({
    Key? key,
    required this.frame,
    required this.image,
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

    double imageLeftPosition = config.additionalImageLeftPercentage * 0.01 * containerWidth;
    double imageTopPosition = config.additionalImageTopPercentage * 0.01 * containerHeight;

    final double additionalImageWidth = config.additionalImageSizeWidthPercentage * containerWidth / 100;
    final double additionalImageHeight = config.additionalImageSizeHeightPercentage * containerHeight / 100;

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
              image: MemoryImage(frame),
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
              Positioned(
                left: imageLeftPosition,
                top: imageTopPosition,
                child: Image.memory(
                  // You'll need to pass the Uint8List for the additional image into the PreviewScreen
                  image,
                  width: additionalImageWidth, // or use config data if dynamic
                  height: additionalImageHeight,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
