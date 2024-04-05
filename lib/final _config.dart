class BusinessNameConfig {
  final String fontStyle;
  final String fontName;
  final double fontSizePercentage;
  final String fontColor;
  final Position textPosition;

  BusinessNameConfig({
    required this.fontStyle,
    required this.fontName,
    required this.fontSizePercentage,
    required this.fontColor,
    required this.textPosition,
  });
}

class LogoImageConfig {
  final Position logoPosition;
  final Size logoSize;

  LogoImageConfig({required this.logoPosition, required this.logoSize});
}

class Position {
  final double topMargin;
  final double leftMargin;

  Position({required this.topMargin, required this.leftMargin});
}

class Size {
  final double width;
  final double height;

  Size({required this.width, required this.height});
}
