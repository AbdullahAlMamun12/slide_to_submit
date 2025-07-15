import 'package:flutter/material.dart';
import 'src/animated_slide_arrow.dart';
import 'src/default_slider.dart';

export 'src/animated_slide_arrow.dart';

/// A customizable slide-to-submit button widget for Flutter.
///
/// Use this widget to create an interactive slide action that triggers
/// a callback when dragged beyond a certain threshold.
///
/// ```dart
/// SlideToSubmit(
///   onSubmit: () {
///     // Handle submission
///   },
/// )
/// ```
@immutable
class SlideToSubmit extends StatefulWidget {
  /// Callback executed when the slider reaches the submit threshold.
  final VoidCallback onSubmit;

  /// The slide distance ratio required to trigger submission.
  ///
  /// Must be between 0.0 and 1.0.
  final double threshold;

  /// The duration of the bounce-back animation when submission is not triggered.
  final Duration bounceDuration;

  /// Padding around the entire slide-to-submit widget.
  final EdgeInsetsGeometry padding;

  /// Decoration for the static background layer.
  final BoxDecoration backgroundDecoration;

  /// Decoration for the foreground (sliding) widget.
  final BoxDecoration foregroundDecoration;

  /// The slider widget (usually a styled container with icon/text).
  final Widget slider;

  /// Optional widget to show as a hint (e.g. sliding arrow).
  final Widget? hint;

  /// Width of the draggable slider.
  final double sliderWidth;

  /// Total height of the widget.
  final double height;

  /// Creates a default pre-styled [SlideToSubmit] button.
  factory SlideToSubmit({
    Key? key,
    required VoidCallback onSubmit,
    Color backgroundColor = const Color(0xff1A4239),
    String? text,
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    IconData? sliderIcon,
    Color sliderIconColor = Colors.white,
    Color foregroundColor = const Color(0xff22574A),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(40)),
    double height = 76,
    double sliderWidth = 128,
    double threshold = 0.8,
    Duration bounceDuration = const Duration(milliseconds: 500),
    bool showArrow = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
  }) {
    final resolvedPadding = padding.resolve(TextDirection.ltr);
    final double sliderHeight = height - (resolvedPadding.top + resolvedPadding.bottom);

    return SlideToSubmit._(
      padding: padding,
      onSubmit: onSubmit,
      threshold: threshold,
      bounceDuration: bounceDuration,
      height: height,
      sliderWidth: sliderWidth,
      backgroundDecoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      foregroundDecoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: borderRadius,
      ),
      slider: DefaultSlider(
        text: text,
        textStyle: textStyle,
        sliderIcon: sliderIcon,
        sliderIconColor: sliderIconColor,
        foregroundColor: foregroundColor,
        borderRadius: borderRadius,
        width: sliderWidth,
        height: sliderHeight,
      ),
      hint: showArrow
          ? Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedSlideArrow(
            arrowImage: const AssetImage(
              'assets/arrow_right.png',
              package: 'slide_to_submit_button',
            ),
          ),
        ),
      )
          : null,
    );
  }

  /// Creates a fully custom [SlideToSubmit] button.
  const SlideToSubmit.custom({
    Key? key,
    this.padding = const EdgeInsets.all(8),
    required this.onSubmit,
    this.backgroundDecoration = const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    this.foregroundDecoration = const BoxDecoration(
      color: Color(0xff2e7d32),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    required this.slider,
    required this.sliderWidth,
    this.height = 76,
    this.hint,
    this.threshold = 0.8,
    this.bounceDuration = const Duration(milliseconds: 500),
  }) : assert(threshold >= 0.0 && threshold <= 1.0);

  const SlideToSubmit._({
    required this.onSubmit,
    required this.backgroundDecoration,
    required this.foregroundDecoration,
    required this.slider,
    required this.sliderWidth,
    required this.height,
    required this.padding,
    this.hint,
    this.threshold = 0.8,
    this.bounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<SlideToSubmit> createState() => _SlideToSubmitState();
}

class _SlideToSubmitState extends State<SlideToSubmit>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isSubmitted = false;
  late double _maxSlide;
  late final AnimationController _bounceController;
  Animation<double>? _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: widget.bounceDuration,
    )..addListener(() {
      if (mounted) {
        setState(() {
          _dragPosition = _bounceAnimation?.value ?? 0.0;
        });
      }
    });
  }

  void _resetWithBounce() {
    _bounceAnimation = Tween<double>(
      begin: _dragPosition,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.bounceOut,
      ),
    );
    _bounceController.forward(from: 0);
    _isSubmitted = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isSubmitted) return;
    _bounceController.stop();
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx)
          .clamp(0.0, _maxSlide);
    });
  }

  void _handleDragEnd(DragEndDetails _) {
    if (_isSubmitted) return;

    if (_dragPosition >= _maxSlide * widget.threshold) {
      setState(() {
        _isSubmitted = true;
        _dragPosition = _maxSlide;
      });
      widget.onSubmit();
    } else {
      _resetWithBounce();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedPadding =
        widget.padding.resolve(Directionality.of(context));
        _maxSlide = constraints.maxWidth -
            widget.sliderWidth -
            (resolvedPadding.left + resolvedPadding.right);

        return Container(
          height: widget.height,
          decoration: widget.backgroundDecoration,
          padding: widget.padding,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (widget.hint != null && !_isSubmitted)
                SizedBox.expand(child: widget.hint!),
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: _handleDragEnd,
                  child: Container(
                    width: widget.sliderWidth,
                    decoration: widget.foregroundDecoration,
                    child: widget.slider,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}