import 'package:flutter/material.dart';

extension WidgetExtensions on BuildContext {
  Widget divider({double? height}) => SizedBox(height: height ?? 30);

  Widget dividerWidth({double? width}) => SizedBox(width: width ?? 30);
}
