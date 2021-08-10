// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// COPIED FROM https://github.com/martinory/Androidish-InkWell

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const Duration _kUnconfirmedSplashDuration = Duration(seconds: 1);
const Duration _kSplashFadeDuration = Duration(milliseconds: 200);
const Duration _kSplashFadeInDuration = Duration(milliseconds: 50);

const double _kSplashConfirmedVelocity = 1.0; // logical pixels per millisecond

const Curve _kSplashCurve = Curves.easeOutQuart;

RectCallback? _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null && containedInkWell) {
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback? rectCallback, Offset? position) {
  if (containedInkWell) {
    final size = rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position!);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final d2 = (position - bounds.topRight(Offset.zero)).distance;
  final d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

class _MaterialInkSplashFactory extends InteractiveInkFeatureFactory {
  const _MaterialInkSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return MaterialInkSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// A visual reaction on a piece of [Material] to user input.
///
/// A circular ink feature whose origin starts at the input touch point
/// and whose radius expands from zero.
///
/// This object is rarely created directly. Instead of creating an ink splash
/// directly, consider using an InkResponse or [InkWell] widget, which uses
/// gestures (such as tap and long-press) to trigger ink splashes.
///
/// See also:
///
///  * [InkRipple], which is an ink splash feature that expands more
///    aggressively than this class does.
///  * InkResponse, which uses gestures to trigger ink highlights and ink
///    splashes in the parent [Material].
///  * [InkWell], which is a rectangular InkResponse (the most common type of
///    ink response).
///  * [Material], which is the widget on which the ink splash is painted.
///  * [InkHighlight], which is an ink feature that emphasizes a part of a
///    [Material].
class MaterialInkSplash extends InteractiveInkFeature {
  /// Begin a splash, centered at position relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If `containedInkWell` is true, then the splash will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by `rectCallback`, if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  /// The ink splash is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the splash is removed, `onRemoved` will be called.
  MaterialInkSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    required Color color,
    Offset? position,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        _textDirection = textDirection,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    _radiusController = AnimationController(
        duration: _kUnconfirmedSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = _radiusController.drive(CurveTween(curve: _kSplashCurve));
    _alphaController = AnimationController(
        duration: _kSplashFadeDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha = _alphaController.drive(IntTween(
      begin: color.alpha,
      end: 0,
    ));

    _alphaFadeInController = AnimationController(
        duration: _kSplashFadeInDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaFadeInStatusChanged);
    _alphaFadeIn = _alphaFadeInController.drive(IntTween(
      begin: color.alpha,
      end: 0,
    ));

    _alphaFadeInController.forward();

    // Future<void>.delayed(
    //     _kSplashDurationUntilCanceled, () => _alphaController?.forward());

    controller.addInkFeature(this);
  }

  final Offset? _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final bool _repositionToReferenceBox;
  final TextDirection _textDirection;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _alpha;
  late AnimationController _alphaController;
  late Animation<int> _alphaFadeIn;
  late AnimationController _alphaFadeInController;

  /// Used to specify this type of ink splash for an [InkWell], InkResponse
  /// or material [Theme].
  static const InteractiveInkFeatureFactory splashFactory =
      _MaterialInkSplashFactory();

  @override
  void confirm() {
    final duration = (_targetRadius / _kSplashConfirmedVelocity).floor();
    _radiusController
      ..duration = Duration(milliseconds: duration)
      ..forward();
    _alphaController.forward();
  }

  @override
  void cancel() {
    _alphaController.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  void _handleAlphaFadeInStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _alphaFadeInController.dispose();
      // _alphaFadeInController = null;
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController.dispose();

    if (_alphaFadeInController.isDismissed) {
      _alphaFadeInController.dispose();
    }
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final paint = Paint()
      ..color = color.withAlpha(_alpha.value - _alphaFadeIn.value);
    var center = _position;
    if (_repositionToReferenceBox) {
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _radiusController.value);
    }
    final originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }
    if (_clipCallback != null) {
      final rect = _clipCallback!();
      if (_customBorder != null) {
        canvas.clipPath(
            _customBorder!.getOuterPath(rect, textDirection: _textDirection));
      } else if (_borderRadius != BorderRadius.zero) {
        canvas.clipRRect(RRect.fromRectAndCorners(
          rect,
          topLeft: _borderRadius.topLeft,
          topRight: _borderRadius.topRight,
          bottomLeft: _borderRadius.bottomLeft,
          bottomRight: _borderRadius.bottomRight,
        ));
      } else {
        canvas.clipRect(rect);
      }
    }

    final k = _targetRadius * 1.05;
    final m = _targetRadius * .25;
    canvas.drawCircle(center!, _radius.value * k + m, paint);
    canvas.restore();
  }
}
