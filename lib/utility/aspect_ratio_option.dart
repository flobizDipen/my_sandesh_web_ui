enum AspectRatioOption {
  oneToOne,
  threeToTwo,
  fiveToThree,
  fourToThree,
  fiveToFour,
  sixteenToNine,
}

class AspectRatioSize {
  final double width;
  final double height;

  const AspectRatioSize({
    required this.width,
    required this.height,
  });
}

// Helper extension to get dimensions based on enum
extension AspectRatioOptionExtension on AspectRatioOption {
  AspectRatioSize get sizeSmall => _getSizeVariant(step: 1);
  AspectRatioSize get sizeMedium => _getSizeVariant(step: 2);
  AspectRatioSize get sizeLarge => _getSizeVariant(step: 3);
  AspectRatioSize get sizeExtraLarge => _getSizeVariant(step: 4);
  AspectRatioSize get sizeExtraExtraLarge => _getSizeVariant(step: 5);

  AspectRatioSize _getSizeVariant({required int step}) {
    // Define base dimensions for the smallest size, then multiply according to the step for scaling.
    Map<AspectRatioOption, AspectRatioSize> baseSizes = {
      AspectRatioOption.oneToOne: const AspectRatioSize(width: 300, height: 300),
      AspectRatioOption.threeToTwo: const AspectRatioSize(width: 378, height: 252),
      AspectRatioOption.fiveToThree: const AspectRatioSize(width: 400, height: 240),
      AspectRatioOption.fourToThree: const AspectRatioSize(width: 520, height: 390),
      AspectRatioOption.fiveToFour: const AspectRatioSize(width: 400, height: 320),
      AspectRatioOption.sixteenToNine: const AspectRatioSize(width: 320, height: 180),
    };

    // Calculate scaled dimensions
    AspectRatioSize baseSize = baseSizes[this] ?? const AspectRatioSize(width: 300, height: 300);
    double scale = step * 100; // Adjust the scale factor as needed
    return AspectRatioSize(
      width: baseSize.width + scale,
      height: baseSize.height + (scale * (baseSize.height / baseSize.width)),
    );
  }

  String get name {
    switch (this) {
      case AspectRatioOption.oneToOne:
        return "1:1";
      case AspectRatioOption.threeToTwo:
        return "3:2";
      case AspectRatioOption.fiveToThree:
        return "5:3";
      case AspectRatioOption.fourToThree:
        return "4:3";
      case AspectRatioOption.fiveToFour:
        return "5:4";
      case AspectRatioOption.sixteenToNine:
        return "16:9";
      default:
        return "Unknown";
    }
  }
}
