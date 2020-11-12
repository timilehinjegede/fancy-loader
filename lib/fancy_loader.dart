library fancy_loader;

import 'dart:ui';

import 'package:flutter/material.dart';

// TODO: Add support for size transitions
enum TransitionType { scale, slide, fade, size }

class FancyLoader {
  final Duration duration;
  final TransitionType transitionType;
  final Widget child;
  final double blurValue;
  final Color backgroundColor;
  final Curve curve;
  final Curve reverseCurve;
  final bool isLoaderDismissible;

  const FancyLoader({
    Key key,
    this.duration,
    this.transitionType,
    this.blurValue,
    this.backgroundColor,
    this.child,
    this.curve,
    this.reverseCurve,
    this.isLoaderDismissible,
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: backgroundColor,
      barrierDismissible: isLoaderDismissible ?? true,
      builder: (context) {
        return _FancyLoaderLogic(
          duration: duration,
          transitionType: transitionType,
          child: child,
          blurValue: blurValue,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

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
