import 'package:my_sandesh_web_ui/component/text_field_type.dart';
import 'package:my_sandesh_web_ui/final _config.dart';

import 'logo_image.dart';
import 'component/text_element.dart';

class Configuration {
  final double containerWidth;
  final double containerHeight;
  final Map<TextFieldType, TextConfig?> textConfigs;
  final LogoImageConfig? logoImageConfig;

  Configuration(
      {required this.containerWidth,
      required this.containerHeight,
      required this.textConfigs,
      required this.logoImageConfig});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> elementsJson = {};

    textConfigs.forEach((type, config) {
      elementsJson[type.name.toString()] = config?.toJson();
    });

    // Add logo configuration if exists
    elementsJson['logoImage'] = logoImageConfig?.toJson();

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
  required LogoImage? logo,
}) {

  Map<TextFieldType, TextConfig?> textConfigs = {};
  for (var element in textElements) {
    // Check if the text element is added before generating its config
    if (element.isAdded) {
      textConfigs[element.type] = getTextConfig(containerWidth, containerHeight, element.fontProperties);
    } else {
      // If not added, you can choose to not include it in the map or explicitly set it to null
      // This decision depends on how you plan to use these configurations later
      textConfigs[element.type] = null;
    }
  }

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
  LogoImage logoImage,
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
