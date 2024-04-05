import 'package:my_sandesh_web_ui/component/font_properties_dialog.dart';
import 'package:my_sandesh_web_ui/final _config.dart';

import 'business_name.dart';
import 'component/text_element.dart';

class Configuration {
  final double containerWidth;
  final double containerHeight;

  final BusinessNameConfig businessNameConfig;
  final PhoneNumberConfig phoneNumberConfig;
  final AddressConfig addressConfig;
  final TaglineConfig taglineConfig;
  final LogoImageConfig? logoImageConfig;

  Configuration(
      {required this.containerWidth,
      required this.containerHeight,
      required this.businessNameConfig,
      required this.addressConfig,
      required this.taglineConfig,
      required this.phoneNumberConfig,
      required this.logoImageConfig});

  Map<String, dynamic> toJson() {
    return {
      "aspectRatio": "1:1",
      "elements": {
        "businessName": {
          "fontWeight": businessNameConfig.fontWeight,
          "fontName": businessNameConfig.fontName,
          "fontSize": businessNameConfig.fontSizePercentage,
          "fontColor": businessNameConfig.fontColor,
          "positioning": {
            "top": businessNameConfig.textPosition.topMargin,
            "left": businessNameConfig.textPosition.leftMargin,
          }
        },
        "phoneNumber": {
          "fontWeight": phoneNumberConfig.fontWeight,
          "fontName": phoneNumberConfig.fontName,
          "fontSize": phoneNumberConfig.fontSizePercentage,
          "fontColor": phoneNumberConfig.fontColor,
          "positioning": {
            "top": phoneNumberConfig.textPosition.topMargin,
            "left": phoneNumberConfig.textPosition.leftMargin,
          }
        },
        "address": {
          "fontWeight": phoneNumberConfig.fontWeight,
          "fontName": phoneNumberConfig.fontName,
          "fontSize": phoneNumberConfig.fontSizePercentage,
          "fontColor": phoneNumberConfig.fontColor,
          "positioning": {
            "top": phoneNumberConfig.textPosition.topMargin,
            "left": phoneNumberConfig.textPosition.leftMargin,
          }
        },
        "tagline": {
          "fontWeight": phoneNumberConfig.fontWeight,
          "fontName": phoneNumberConfig.fontName,
          "fontSize": phoneNumberConfig.fontSizePercentage,
          "fontColor": phoneNumberConfig.fontColor,
          "positioning": {
            "top": phoneNumberConfig.textPosition.topMargin,
            "left": phoneNumberConfig.textPosition.leftMargin,
          }
        },
        "logoImage": {
          "position": {
            "left": logoImageConfig?.logoPosition.leftMargin,
            "top": logoImageConfig?.logoPosition.topMargin,
          },
          "size": {"width": logoImageConfig?.logoSize.width, "height": logoImageConfig?.logoSize.height},
        }
      }
    };
  }
}

Configuration createConfiguration({
  required double containerWidth,
  required double containerHeight,
  required FontProperties businessName,
  required FontProperties phoneNumber,
  required FontProperties address,
  required FontProperties tagline,
  required Logo? logo,
}) {
  // Convert the fontColor to a hex string properly

  final businessNameConfig = getBusinessNameConfig(containerWidth, containerHeight, businessName);
  final phoneNumberConfig = getPhoneNumberConfig(containerWidth, containerHeight, phoneNumber);
  final addressConfig = getAddressConfig(containerWidth, containerHeight, address);
  final taglineConfig = getTaglineConfig(containerWidth, containerHeight, tagline);

  LogoImageConfig? logoImageConfig;
  if (logo == null) {
    logoImageConfig = null;
  } else {
    logoImageConfig = getLogoImageConfig(containerWidth, containerHeight, logo);
  }

  return Configuration(
      containerWidth: containerWidth,
      containerHeight: containerHeight,
      businessNameConfig: businessNameConfig,
      phoneNumberConfig: phoneNumberConfig,
      addressConfig: addressConfig,
      taglineConfig: taglineConfig,
      logoImageConfig: logoImageConfig);
}

BusinessNameConfig getBusinessNameConfig(
  double containerWidth,
  double containerHeight,
  FontProperties businessNameText,
) {
  String fontColorHex = '#${businessNameText.textColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (businessNameText.textSize / containerWidth) * 100;

  final textPosition = businessNameText.getTextPosition();
  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  return BusinessNameConfig(
      fontWeight: businessNameText.fontWeight.value.toString(),
      fontName: businessNameText.fontFamily,
      fontSizePercentage: fontSizePercentage,
      fontColor: fontColorHex,
      textPosition: Position(topMargin: topMarginPercentage, leftMargin: leftMarginPercentage));
}

PhoneNumberConfig getPhoneNumberConfig(
  double containerWidth,
  double containerHeight,
  FontProperties phoneNumber,
) {
  String fontColorHex = '#${phoneNumber.textColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (phoneNumber.textSize / containerWidth) * 100;

  final textPosition = phoneNumber.getTextPosition();
  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  return PhoneNumberConfig(
      fontWeight: phoneNumber.fontWeight.value.toString(),
      fontName: phoneNumber.fontFamily,
      fontSizePercentage: fontSizePercentage,
      fontColor: fontColorHex,
      textPosition: Position(topMargin: topMarginPercentage, leftMargin: leftMarginPercentage));
}

AddressConfig getAddressConfig(
  double containerWidth,
  double containerHeight,
  FontProperties phoneNumber,
) {
  String fontColorHex = '#${phoneNumber.textColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (phoneNumber.textSize / containerWidth) * 100;

  final textPosition = phoneNumber.getTextPosition();
  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  return AddressConfig(
      fontWeight: phoneNumber.fontWeight.value.toString(),
      fontName: phoneNumber.fontFamily,
      fontSizePercentage: fontSizePercentage,
      fontColor: fontColorHex,
      textPosition: Position(topMargin: topMarginPercentage, leftMargin: leftMarginPercentage));
}

TaglineConfig getTaglineConfig(
  double containerWidth,
  double containerHeight,
  FontProperties phoneNumber,
) {
  String fontColorHex = '#${phoneNumber.textColor.value.toRadixString(16).padLeft(8, '0')}';

  // Assuming text size scales with width, convert fontSize to a percentage of containerWidth
  final fontSizePercentage = (phoneNumber.textSize / containerWidth) * 100;

  final textPosition = phoneNumber.getTextPosition();
  // Calculate the position of text as a percentage of container's dimensions
  final leftMarginPercentage = (textPosition.dx / containerWidth) * 100;
  final topMarginPercentage = (textPosition.dy / containerHeight) * 100;

  return TaglineConfig(
      fontWeight: phoneNumber.fontWeight.value.toString(),
      fontName: phoneNumber.fontFamily,
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
