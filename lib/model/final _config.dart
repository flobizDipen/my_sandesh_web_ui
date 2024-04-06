
import 'package:my_sandesh_web_ui/component/text_field_type.dart';

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

class TextConfig {
  final String fontWeight;
  final String fontName;
  final double fontSizePercentage;
  final String fontColor;
  final Position textPosition;

  TextConfig({
    required this.fontWeight,
    required this.fontName,
    required this.fontSizePercentage,
    required this.fontColor,
    required this.textPosition,
  });

  Map<String, dynamic> toJson() => {
        'fontWeight': fontWeight,
        'fontName': fontName,
        'fontSizePercentage': fontSizePercentage,
        'fontColor': fontColor,
        'textPosition': textPosition.toJson(), // Assuming Position also has a .toJson()
      };
}

class LogoImageConfig {
  final Position logoPosition;
  final Size logoSize;

  LogoImageConfig({required this.logoPosition, required this.logoSize});

  Map<String, dynamic> toJson() => {
        'size': logoSize.toJson(),
        'position': logoPosition.toJson(), // Assuming Position also has a .toJson()
      };
}

class Position {
  final double topMargin;
  final double leftMargin;

  Position({required this.topMargin, required this.leftMargin});

  Map<String, dynamic> toJson() => {
        'topMargin': topMargin,
        'leftMargin': leftMargin,
      };
}

class Size {
  final double width;
  final double height;

  Size({required this.width, required this.height});

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
      };
}
