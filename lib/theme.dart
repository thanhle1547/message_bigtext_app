import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_bigtext_app/constants.dart';
import 'dart:math' as math;

final appBarTheme = AppBarTheme(centerTitle: true, elevation: 0);

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: kcContentColorDarkTheme,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kcContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kcContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kcPrimaryColor,
      secondary: kcSecondaryColor,
      error: kcErrorColor,
    ),
  );
}

ThemeData darkThemeData2(BuildContext context) {
  ThemeData themeData = ThemeData.dark();

  return themeData.copyWith(
    primaryColor: Colors.black,
    accentColor: Colors.white,
    cardColor: Colors.white24,
    hintColor: Colors.black38,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black38,
      selectionColor: Colors.white,
      selectionHandleColor: Colors.black38,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kcContentColorDarkTheme, size: 26),
    textTheme: GoogleFonts.interTextTheme(_darkTextThemeData(themeData)).apply(
      displayColor: Colors.white,
      bodyColor: kcContentColorDarkTheme,
    ),
    hoverColor: Color(0x26FFFFFF), // white15
    splashColor: Color(0x2EFFFFFF), // white18
    splashFactory: CustomSplashFactory(),
    canvasColor: Colors.black,
    colorScheme: ColorScheme.dark().copyWith(
      primary: Colors.white,
      secondary: Color(0xD4FFFFFF), // white83
      background: Colors.black38,
      error: kcErrorColor,
    ),
  );
}

TextTheme _darkTextThemeData(ThemeData themeData) {
  final _textTheme = themeData.textTheme; // Theme.of(context).textTheme;

  return _textTheme.copyWith(
    headline3: _textTheme.headline3.copyWith(color: Colors.white),
    headline4: _textTheme.headline4.copyWith(color: Colors.white),
    headline5: _textTheme.headline5.copyWith(
      color: Colors.white,
      fontSize: 26,
    ),
    headline6: _textTheme.headline6.copyWith(
      color: Colors.white,
      fontSize: 24,
    ),
    subtitle1: _textTheme.subtitle1.copyWith(
      color: Colors.white,
      fontSize: 22,
    ),
    subtitle2: _textTheme.subtitle2.copyWith(
      color: Colors.white,
      fontSize: 20,
    ),
    bodyText1: _textTheme.bodyText1.copyWith(
      color: Colors.white,
      fontSize: 22,
    ),
    bodyText2: _textTheme.bodyText2.copyWith(
      color: Colors.white,
      fontSize: 20,
    ),
    button: _textTheme.button.copyWith(
      color: Colors.white,
      fontSize: 20,
    ),
  );
}

/// https://stackoverflow.com/a/51116178
class CustomSplashFactory extends InteractiveInkFeatureFactory {
  const CustomSplashFactory();

  @override
  InteractiveInkFeature create({
    MaterialInkController controller,
    RenderBox referenceBox,
    Offset position,
    Color color,
    @required TextDirection textDirection,
    bool containedInkWell = false,
    rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    onRemoved,
  }) {
    return new CustomSplash(
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
    );
  }
}

class CustomSplash extends InteractiveInkFeature {
  /// Used to specify this type of ink splash for an [InkWell], [InkResponse]
  /// or material [Theme].
  static const InteractiveInkFeatureFactory splashFactory =
      const CustomSplashFactory();

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
  CustomSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    Offset position,
    Color color,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ??
            ((customBorder as RoundedRectangleBorder)?.borderRadius
                as BorderRadius) ??
            BorderRadius.zero,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    assert(_borderRadius != null);
    _radiusController = new AnimationController(
        duration: kUnconfirmedSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = new Tween<double>(begin: kSplashInitialSize, end: _targetRadius)
        .animate(_radiusController);
    _alphaController = new AnimationController(
        duration: kSplashFadeDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha = new IntTween(begin: color.alpha, end: 0).animate(_alphaController);

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final double _targetRadius;
  final RectCallback _clipCallback;
  final bool _repositionToReferenceBox;

  Animation<double> _radius;
  AnimationController _radiusController;

  Animation<int> _alpha;
  AnimationController _alphaController;

  @override
  void confirm() {
    final int duration = (_targetRadius / kSplashConfirmedVelocity).floor();
    _radiusController
      ..duration = new Duration(milliseconds: duration)
      ..forward();
    _alphaController.forward();
  }

  @override
  void cancel() {
    _alphaController?.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController.dispose();
    _alphaController = null;
    super.dispose();
  }

  RRect _clipRRectFromRect(Rect rect) {
    return new RRect.fromRectAndCorners(
      rect,
      topLeft: _borderRadius.topLeft,
      topRight: _borderRadius.topRight,
      bottomLeft: _borderRadius.bottomLeft,
      bottomRight: _borderRadius.bottomRight,
    );
  }

  void _clipCanvasWithRect(Canvas canvas, Rect rect, {Offset offset}) {
    Rect clipRect = rect;
    if (offset != null) {
      clipRect = clipRect.shift(offset);
    }
    if (_borderRadius != BorderRadius.zero) {
      canvas.clipRRect(_clipRRectFromRect(clipRect));
    } else {
      canvas.clipRect(clipRect);
    }
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = new Paint()..color = color.withAlpha(_alpha.value);
    Offset center = _position;
    if (_repositionToReferenceBox)
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _radiusController.value);
    final Offset originOffset = MatrixUtils.getAsTranslation(transform);
    if (originOffset == null) {
      canvas.save();
      canvas.transform(transform.storage);
      if (_clipCallback != null) {
        _clipCanvasWithRect(canvas, _clipCallback());
      }
      canvas.drawCircle(center, _radius.value, paint);
      canvas.restore();
    } else {
      if (_clipCallback != null) {
        canvas.save();
        _clipCanvasWithRect(canvas, _clipCallback(), offset: originOffset);
      }
      canvas.drawCircle(center + originOffset, _radius.value, paint);
      if (_clipCallback != null) canvas.restore();
    }
  }
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback rectCallback, Offset position) {
  if (containedInkWell) {
    final Size size =
        rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

RectCallback _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}
