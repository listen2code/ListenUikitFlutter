import 'package:flutter/material.dart';

class CommonBottomSheet {
  CommonBottomSheet._();

  /// Displays a customized modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    Color? backgroundColor,
    double topRadius = 20.0,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius),
        ),
      ),
      builder: builder,
    );
  }
}
