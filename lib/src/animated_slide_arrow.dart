import 'package:flutter/material.dart';

/// A widget that displays a continuously looping animated arrow,
/// typically used to indicate a sliding or swipe action.
///
/// This widget can be used independently or integrated into buttons,
/// forms, or custom UI to draw user attention to a sliding gesture.
class AnimatedSlideArrow extends StatefulWidget {
  /// Creates an [AnimatedSlideArrow] widget.
  ///
  /// The [arrowImage] parameter is required and specifies the image to use
  /// for the arrow. You can customize the duration, delay, direction,
  /// animation curve, and arrow size.
  const AnimatedSlideArrow({
    super.key,
    this.animationDuration = const Duration(seconds: 2),
    this.animationDelay = const Duration(milliseconds: 200),
    this.beginOffset = const Offset(-2, 0),
    this.endOffset = const Offset(0, 0),
    this.slideCurve = Curves.easeInOutQuart,
    this.arrowHeight = 18,
    required this.arrowImage,
  });

  /// The duration of one complete slide and fade animation cycle.
  final Duration animationDuration;

  /// The delay between the end of one animation and the start of the next.
  final Duration animationDelay;

  /// The starting position of the arrow in the slide animation.
  ///
  /// Defaults to `Offset(-2, 0)` to start the arrow off-screen to the left.
  final Offset beginOffset;

  /// The ending position of the arrow in the slide animation.
  ///
  /// Defaults to `Offset(0, 0)` to end at the arrow’s natural position.
  final Offset endOffset;

  /// The curve used for the slide animation.
  final Curve slideCurve;

  /// The image to use for the arrow.
  ///
  /// Typically an [AssetImage] or [NetworkImage].
  final ImageProvider arrowImage;

  /// The height of the arrow image.
  ///
  /// The width will be determined automatically based on the image aspect ratio.
  final double arrowHeight;

  @override
  State<AnimatedSlideArrow> createState() => _AnimatedSlideArrowState();
}

class _AnimatedSlideArrowState extends State<AnimatedSlideArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: widget.endOffset,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.slideCurve,
      ),
    );

    _fadeAnimation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _startLooping();
  }

  /// Starts the animation loop recursively.
  void _startLooping() {
    _controller.forward().whenComplete(() {
      _controller.reset();
      Future.delayed(widget.animationDelay, () {
        if (mounted) {
          _startLooping();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Image(
          image: widget.arrowImage,
          height: widget.arrowHeight,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}