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

  AspectRatioSize({
    required this.width,
    required this.height,
  });
}

// Helper extension to get dimensions based on enum
extension AspectRatioOptionExtension on AspectRatioOption {
  AspectRatioSize get size {
    switch (this) {
      case AspectRatioOption.oneToOne:
        return AspectRatioSize(width: 500, height: 500);
      case AspectRatioOption.threeToTwo:
        return AspectRatioSize(width: 600, height: 400);
      case AspectRatioOption.fiveToThree:
        return AspectRatioSize(width: 800, height: 480);
      case AspectRatioOption.fourToThree:
        return AspectRatioSize(width: 640, height: 480);
      case AspectRatioOption.fiveToFour:
        return AspectRatioSize(width: 600, height: 480);
      case AspectRatioOption.sixteenToNine:
        return AspectRatioSize(width: 640, height: 360);
      default:
        return AspectRatioSize(width: 500, height: 500); // Default size
    }
  }
}

extension AspectRatioNameExtension on AspectRatioOption {
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
        return "1:1"; // Default size
    }
  }
}
