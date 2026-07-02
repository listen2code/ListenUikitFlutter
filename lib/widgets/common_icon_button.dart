import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum IconButtonType { filled, outlined, plain }

class CommonIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final IconButtonType type;
  final bool isLoading;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final bool useHaptic;
  final Duration debounceDuration;
  final String? tooltip;

  const CommonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.type = IconButtonType.plain,
    this.isLoading = false,
    this.size = 40,
    this.iconSize = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 10,
    this.useHaptic = true,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.tooltip,
  });

  @override
  State<CommonIconButton> createState() => _CommonIconButtonState();
}

class _CommonIconButtonState extends State<CommonIconButton> {
  int _lastClickTime = 0;

  void _handlePress() {
    if (widget.onPressed == null || widget.isLoading) return;

    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTime < widget.debounceDuration.inMilliseconds) {
      return;
    }
    _lastClickTime = now;

    if (widget.useHaptic) {
      HapticFeedback.lightImpact();
    }

    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final contentColor = widget.foregroundColor ??
        (widget.type == IconButtonType.filled
            ? (widget.backgroundColor == null ? theme.colorScheme.onPrimary : Colors.white)
            : effectiveAccentColor);

    Widget innerChild = widget.isLoading
        ? SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          )
        : IconTheme(
            data: IconThemeData(
              size: widget.iconSize,
              color: contentColor,
            ),
            child: widget.icon,
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );

    final VoidCallback? effectiveOnPressed =
        (widget.onPressed == null || widget.isLoading) ? null : _handlePress;

    Widget button;
    switch (widget.type) {
      case IconButtonType.filled:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveAccentColor,
            disabledBackgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            foregroundColor: contentColor,
            elevation: 0,
            shape: shape,
            padding: EdgeInsets.zero,
            minimumSize: Size(widget.size, widget.size),
            maximumSize: Size(widget.size, widget.size),
          ),
          child: innerChild,
        );
        break;
      case IconButtonType.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: contentColor,
            side: BorderSide(
              color: effectiveOnPressed == null
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
                  : effectiveAccentColor,
              width: 1.5,
            ),
            shape: shape,
            padding: EdgeInsets.zero,
            minimumSize: Size(widget.size, widget.size),
            maximumSize: Size(widget.size, widget.size),
          ),
          child: innerChild,
        );
        break;
      case IconButtonType.plain:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: contentColor,
            shape: shape,
            padding: EdgeInsets.zero,
            minimumSize: Size(widget.size, widget.size),
            maximumSize: Size(widget.size, widget.size),
            splashFactory: NoSplash.splashFactory,
          ),
          child: innerChild,
        );
        break;
    }

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: button,
    );
  }
}
