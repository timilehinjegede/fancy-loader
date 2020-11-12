library fancy_loader;

import 'dart:ui';

import 'package:flutter/material.dart';

// TODO: Add support for size transitions
enum TransitionType { scale, slide, fade, size }

/// creates a [FancyLoader] widget that is used to create beautiful overlay loading animations.
class FancyLoader {
  /// The transition to be used for the [FancyLoader] widget.
  ///
  /// Can be either scale, slide, fade or size transitions. Must not be null.
  final TransitionType transitionType;

  /// The duration of the animation to be used in [transitionType]
  final Duration duration;

  /// The widget to be passed as a child to the [FancyLoader] widget.
  ///
  /// This is the widget that animates
  final Widget child;

  /// The amount of blur to apply to the background of the [FancyLoader] widget
  final double blurValue;

  /// The background color to be used for the [FancyLoader] widget.
  ///
  /// This is used to fill the back of the [FancyLoader] widget.
  final Color backgroundColor;

  /// The curve to be applied to the type of transition in [transitionType]
  final Curve curve;

  /// The reverse curve to be applied to the type os transition in [transitionType]
  ///
  /// If [reverseCurve] is null, [curve] will be used as the value of the [reverseCurve].
  final Curve reverseCurve;

  /// Whether the [FancyLoader] can be dismissed or not after it is showed in your widget tree.
  final bool isLoaderDismissible;

  const FancyLoader({
    this.duration,
    this.transitionType,
    this.blurValue,
    this.backgroundColor,
    this.child,
    this.curve,
    this.reverseCurve,
    this.isLoaderDismissible,
  });

  /// Used to show the [FancyLoader]
  ///
  /// the [show] method is called on the [FancyLoader] to show the [FancyLoader] in your widget tree or apps.
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: backgroundColor,
      barrierDismissible: isLoaderDismissible ?? true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: _FancyLoaderLogic(
            duration: duration,
            transitionType: transitionType,
            child: child,
            blurValue: blurValue,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );
  }

  /// Used to remove the [FancyLoader]
  ///
  /// the [dismiss] method is called on the [FancyLoader] to remove the [FancyLoader] in your widget tree or apps.
  void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _FancyLoaderLogic extends StatefulWidget {
  final Duration duration;
  final TransitionType transitionType;
  final Widget child;
  final double blurValue;
  final Color backgroundColor;

  const _FancyLoaderLogic(
      {Key key, this.duration, this.transitionType, this.blurValue, this.backgroundColor, this.child})
      : super(key: key);

  @override
  _FancyLoaderLogicState createState() => _FancyLoaderLogicState();
}

class _FancyLoaderLogicState extends State<_FancyLoaderLogic> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  Widget _mapTransitionToWidget() {
    final Widget child = widget.child;

    switch (widget.transitionType) {
      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween(begin: 0.1, end: 0.5).animate(_animation),
          child: child,
        );
      case TransitionType.fade:
        return FadeTransition(
          opacity: Tween(begin: 0.1, end: 0.5).animate(_animation),
          child: child,
        );
      // TODO; add support for size transition
      case TransitionType.size:
        return SizeTransition(
          child: child,
        );
      case TransitionType.slide:
        return SlideTransition(
          position: Tween(begin: Offset(0.0, -.5), end: Offset(0.0, .5)).animate(_animation),
          child: child,
        );
      default:
        return AnimatedContainer(
          duration: widget.duration,
          child: child,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInBack,
      parent: _controller,
    );

    _controller.forward();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.stop();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _mapTransitionToWidget(),
    );
  }
}
