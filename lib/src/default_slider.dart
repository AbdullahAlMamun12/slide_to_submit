import 'package:flutter/material.dart';

/// The default widget used as the draggable part of the [SlideToSubmit] button.
///
/// This widget is used by the default [SlideToSubmit()] constructor and can be
/// customized using its properties like [text], [sliderIcon], and [foregroundColor].
class DefaultSlider extends StatelessWidget {
  /// The text displayed on the slider.
  final String? text;

  /// The style for the text on the slider.
  final TextStyle textStyle;

  /// An optional icon to display before the text.
  final IconData? sliderIcon;

  /// The color of the slider icon.
  final Color sliderIconColor;

  /// The background color of the slider.
  final Color foregroundColor;

  /// The border radius of the slider.
  final BorderRadius borderRadius;

  /// The width of the slider.
  final double width;

  /// The height of the slider.
  final double height;

  /// Creates the default slider widget.
  const DefaultSlider({
    super.key,
    this.text,
    required this.textStyle,
    required this.sliderIcon,
    required this.sliderIconColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: foregroundColor,
        // The default slider's border radius should match the parent's radius
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (sliderIcon != null)
            Icon(
              sliderIcon,
              color: sliderIconColor,
            ),
          if (sliderIcon != null && text != null)
            const SizedBox(width: 8),
          if (text != null)
          Text(
            text!,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}