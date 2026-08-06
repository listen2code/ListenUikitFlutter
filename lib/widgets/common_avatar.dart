import 'package:flutter/material.dart';

/// A reusable avatar placeholder component that renders a circular background
/// with a person icon or custom icon.
class CommonAvatar extends StatelessWidget {
  final double size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final Border? border;

  const CommonAvatar({
    super.key,
    this.size = 48.0,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.person,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.dividerColor.withValues(alpha: 0.1);
    final effectiveIconColor = iconColor ?? theme.iconTheme.color ?? Colors.grey;
    final effectiveIconSize = iconSize ?? (size * 0.5);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Center(
        child: Icon(
          icon,
          size: effectiveIconSize,
          color: effectiveIconColor,
        ),
      ),
    );
  }
}
