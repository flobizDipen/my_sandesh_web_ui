import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_sandesh_web_ui/aspect_ratio_option.dart';
import 'package:my_sandesh_web_ui/config.dart';
import 'package:my_sandesh_web_ui/final _config.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List frame;
  final Uint8List? image;
  final Configuration config;
  final AspectRatioSize smallSize;
  final AspectRatioSize largeSize;

  PreviewScreen({
    super.key,
    required this.frame,
    required this.image,
    required this.config,
    required this.smallSize,
    required this.largeSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Previews')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _preview(smallSize.width, smallSize.height),
            const SizedBox(
              width: 30,
            ),
            _preview(largeSize.width, largeSize.height)
          ],
        ),
      ),
    );
  }

  Widget _preview(double containerWidth, double containerHeight) {
    return Column(
      children: [
        Text('Preview $containerWidth x $containerHeight'),
        const SizedBox(
          height: 30,
        ),
        Container(
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
              ..._buildDynamicTextWidgets(
                  containerWidth: containerWidth, containerHeight: containerHeight, config: config),
              if (image != null && config.logoImageConfig != null)
                _logoImage(containerWidth, containerHeight, config.logoImageConfig)
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _buildDynamicTextWidgets({
    required double containerWidth,
    required double containerHeight,
    required Configuration config,
  }) {
    // Assuming 'config.textConfigs' is a Map<TextFieldType, TextConfig?>
    // This will filter out any null configurations and map each remaining config to a widget
    return config.textConfigs.entries
        .where((entry) => entry.value != null) // Ensure config is not null
        .map<Widget>((entry) {
      TextConfig config = entry.value!;
      String textContent = entry.key.labelName; // Assuming TextFieldType has a labelName property
      return _buildTextWidget(
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        config: config,
        textContent: textContent,
      );
    }).toList();
  }

  Widget _buildTextWidget({
    required double containerWidth,
    required double containerHeight,
    required TextConfig config,
    required String textContent,
  }) {
    double scaledFontSize = config.fontSizePercentage * 0.01 * containerWidth;
    double leftPosition = config.textPosition.leftMargin * 0.01 * containerWidth;
    double topPosition = config.textPosition.topMargin * 0.01 * containerHeight;
    final Color fontColor = Color(int.parse(config.fontColor.substring(1), radix: 16) | 0xFF000000);

    return Positioned(
      left: leftPosition,
      top: topPosition,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            textContent,
            style: TextStyle(
              fontSize: scaledFontSize,
              color: fontColor,
              fontFamily: config.fontName,
              fontWeight: stringToFontWeight(config.fontWeight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoImage(double containerWidth, double containerHeight, LogoImageConfig? logoImageConfig) {
    double imageLeftPosition = (logoImageConfig?.logoPosition.leftMargin ?? 0) * 0.01 * containerWidth;
    double imageTopPosition = (logoImageConfig?.logoPosition.topMargin ?? 0) * 0.01 * containerHeight;

    final double additionalImageWidth = (logoImageConfig?.logoSize.width ?? 0) * containerWidth / 100;
    final double additionalImageHeight = (logoImageConfig?.logoSize.height ?? 0) * containerHeight / 100;

    return Positioned(
      left: imageLeftPosition,
      top: imageTopPosition,
      child: Image.memory(
        // You'll need to pass the Uint8List for the additional image into the PreviewScreen
        image!,
        width: additionalImageWidth, // or use config data if dynamic
        height: additionalImageHeight,
      ),
    );
  }

  final Map<String, FontWeight> fontWeightMap = {
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

  // Function to convert a string to a FontWeight
  FontWeight stringToFontWeight(String fontWeightString) {
    // Return the corresponding FontWeight, or FontWeight.normal as a default
    return fontWeightMap[fontWeightString] ?? FontWeight.normal;
  }
}
