import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A unified clickable widget that handles both ripple-based tap (using [InkWell])
/// and non-ripple tap (using [GestureDetector]), with integrated haptic feedback
/// and automatic [Semantics] accessibility support.
class CommonClickable extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  
  /// Whether to show the Material ripple effect. If false, uses [GestureDetector] internally.
  final bool ripple;
  
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  /// Whether to trigger haptic feedback on interaction.
  final bool useHaptic;

  /// Accessibility label.
  final String? semanticLabel;

  /// Whether to exclude this widget from semantics.
  final bool excludeFromSemantics;

  /// Whether the widget is selected.
  final bool? selected;

  const CommonClickable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.ripple = true,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.useHaptic = true,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null && onLongPress == null) {
      return child;
    }

    Widget result;

    if (ripple) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (useHaptic) {
              HapticFeedback.lightImpact();
            }
            onTap?.call();
          },
          onLongPress: () {
            if (useHaptic) {
              HapticFeedback.mediumImpact();
            }
            onLongPress?.call();
          },
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: child,
        ),
      );
    } else {
      result = GestureDetector(
        onTap: () {
          if (useHaptic) {
            HapticFeedback.lightImpact();
          }
          onTap?.call();
        },
        onLongPress: () {
          if (useHaptic) {
            HapticFeedback.mediumImpact();
          }
          onLongPress?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: child,
      );
    }

    if (excludeFromSemantics) {
      return ExcludeSemantics(child: result);
    }

    return Semantics(
      button: true,
      enabled: onTap != null || onLongPress != null,
      label: semanticLabel,
      selected: selected,
      child: result,
    );
  }
}
