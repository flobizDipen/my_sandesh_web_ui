import 'package:my_sandesh_web_ui/component/text_field_type.dart';
import 'package:my_sandesh_web_ui/final _config.dart';

import 'business_name.dart';
import 'component/text_element.dart';

class Configuration {
  final double containerWidth;
  final double containerHeight;
  final Map<TextFieldType, TextConfig> textConfigs;
  final LogoImageConfig? logoImageConfig;

  Configuration(
      {required this.containerWidth,
      required this.containerHeight,
      required this.textConfigs,
      required this.logoImageConfig});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> elementsJson = {};

    textConfigs.forEach((type, config) {
      elementsJson[type.toString()] = config.toJson();
    });

    // Add logo configuration if exists
    if (logoImageConfig != null) {
      elementsJson['logoImage'] = logoImageConfig?.toJson();
    }

    return {
      "containerWidth": containerWidth,
      "containerHeight": containerHeight,
      "elements": elementsJson,
    };
  }
}

Configuration createConfiguration({
  required double containerWidth,
  required double containerHeight,
  required List<TextElement> textElements,
  required Logo? logo,
}) {
  // Convert the fontColor to a hex string properly

// Create a map to hold TextConfigs keyed by TextFieldType
  Map<TextFieldType, TextConfig> textConfigs = textElements.fold<Map<TextFieldType, TextConfig>>({}, (map, element) {
    map[element.type] = getTextConfig(containerWidth, containerHeight, element.fontProperties);
    return map;
  });

  LogoImageConfig? logoImageConfig;
  if (logo == null) {
    logoImageConfig = null;
  } else {
    logoImageConfig = getLogoImageConfig(containerWidth, containerHeight, logo);
  }

  return Configuration(
      containerWidth: containerWidth,
      containerHeight: containerHeight,
      textConfigs: textConfigs,
      logoImageConfig: logoImageConfig);
}

Map<TextFieldType, dynamic> generateDynamicConfig(List<TextElement> textElements, double width, double height) {
  Map<TextFieldType, dynamic> configs = {};

  for (var element in textElements) {
    configs[element.type] = getTextConfig(width, height, element.fontProperties);
  }

  return configs;
}

TextConfig getTextConfig(
  double containerWidth,
  double containerHeight,
  FontProperties fontProperties,
) {
  String fontColorHex = '#${fontProperties.textColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (fontProperties.textSize / containerWidth) * 100;

  final textPosition = fontProperties.getTextPosition();
  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  return TextConfig(
      fontWeight: fontProperties.fontWeight.value.toString(),
      fontName: fontProperties.fontFamily,
      fontSizePercentage: fontSizePercentage,
      fontColor: fontColorHex,
      textPosition: Position(topMargin: topMarginPercentage, leftMargin: leftMarginPercentage));
}

LogoImageConfig getLogoImageConfig(
  double containerWidth,
  double containerHeight,
  Logo logoImage,
) {
  final imagePosition = logoImage.getImagePosition();

  final imageLeftPercentage = imagePosition.dx / containerWidth * 100;
  final imageTopPercentage = imagePosition.dy / containerHeight * 100;

  // Convert imageSize to percentages of the container's dimensions
  final widthPercentage = (logoImage.imageSize.width / containerWidth) * 100;
  final heightPercentage = (logoImage.imageSize.height / containerHeight) * 100;

  return LogoImageConfig(
      logoPosition: Position(leftMargin: imageLeftPercentage, topMargin: imageTopPercentage),
      logoSize: Size(width: widthPercentage, height: heightPercentage));
}
