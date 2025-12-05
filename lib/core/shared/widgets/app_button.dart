import 'package:flutter/material.dart';
import 'package:pg1/core/shared/constants/app_constants.dart';
import 'package:pg1/core/shared/theme/app_color.dart';

class AppButton extends StatefulWidget {
  final String label;
  final void Function()? onPressed;
  final bool isDisabled;

  final double? height;
  final double? width;
  final double borderRadius;
  final FontWeight fontWeight;
  final double fontSize;

  // Dynamic color overrides (nullable)
  final Color? bgColor;
  final Color? bgColorHover;
  final Color? bgColorPressed;
  final Color? bgColorDisabled;

  final Color? textColor;
  final Color? textColorHover;
  final Color? textColorPressed;
  final Color? textColorDisabled;

  final Color? borderColor;
  final Color? borderColorHover;
  final Color? borderColorPressed;
  final Color? borderColorDisabled;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isDisabled = false,
    this.height,
    this.width,
    this.borderRadius = 2000,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,

    // Colors
    this.bgColor,
    this.bgColorHover,
    this.bgColorPressed,
    this.bgColorDisabled,
    this.textColor,
    this.textColorHover,
    this.textColorPressed,
    this.textColorDisabled,
    this.borderColor,
    this.borderColorHover,
    this.borderColorPressed,
    this.borderColorDisabled,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  // Default base color (fallback)
  Color get _base => AppColor.buttonBase;

  bool get _disabled => widget.isDisabled || widget.onPressed == null;

  // -------------------------------
  // Background Color Logic
  // -------------------------------
  Color get _backgroundColor {
    if (_disabled) {
      return widget.bgColorDisabled ?? widget.bgColor?.withOpacity(0.3) ?? _base.withOpacity(0.3);
    }

    if (_isPressed) {
      return widget.bgColorPressed ?? (widget.bgColor != null ? _darken(widget.bgColor!, 0.15) : _darken(_base, 0.15));
    }

    if (_isHovered) {
      return widget.bgColorHover ?? (widget.bgColor != null ? _darken(widget.bgColor!, 0.10) : _darken(_base, 0.10));
    }

    return widget.bgColor ?? _base;
  }

  // -------------------------------
  // Text Color Logic
  // -------------------------------
  Color get _textColor {
    if (_disabled) {
      return widget.textColorDisabled ?? widget.textColor?.withOpacity(0.7) ?? Colors.white.withOpacity(0.7);
    }

    if (_isPressed) {
      return widget.textColorPressed ?? widget.textColor ?? Colors.white;
    }

    if (_isHovered) {
      return widget.textColorHover ?? widget.textColor ?? Colors.white;
    }

    return widget.textColor ?? Colors.white;
  }

  // -------------------------------
  // Border Color Logic
  // -------------------------------
  Color get _borderColor {
    if (_disabled) {
      return widget.borderColorDisabled ?? widget.borderColor?.withOpacity(0.3) ?? Colors.transparent;
    }

    if (_isPressed) {
      return widget.borderColorPressed ?? widget.borderColor ?? Colors.transparent;
    }

    if (_isHovered) {
      return widget.borderColorHover ?? widget.borderColor ?? Colors.transparent;
    }

    return widget.borderColor ?? Colors.transparent;
  }

  // Scale logic
  double get _scale {
    if (_disabled) return 1.0;
    if (_isPressed) return 1.0;
    if (_isHovered) return 1.02;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!_disabled) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!_disabled) setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (!_disabled) setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          if (!_disabled) {
            setState(() => _isPressed = false);
            widget.onPressed?.call();
          }
        },
        onTapCancel: () {
          if (!_disabled) setState(() => _isPressed = false);
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: widget.height ?? kBaseButtonHeight,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: _borderColor, width: 0.75),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: _textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Darken helper
  Color _darken(Color color, double amount) {
    amount = amount.clamp(0, 1);
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness(
      (hsl.lightness - amount * hsl.lightness).clamp(0.0, 1.0),
    );
    return darker.toColor();
  }
}
