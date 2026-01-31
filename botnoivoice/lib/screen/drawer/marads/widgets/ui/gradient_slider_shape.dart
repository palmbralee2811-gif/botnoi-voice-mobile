import 'package:flutter/material.dart';

class GradientSliderTrackShape extends SliderTrackShape {
  final Gradient gradient;
  final bool darkenInactive;

  const GradientSliderTrackShape(
      {required this.gradient, this.darkenInactive = true});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete);

    // วาดเส้นสีเทา (Inactive)
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height)),
        inactivePaint);

    // วาดเส้น Gradient (Active)
    if (isEnabled && thumbCenter.dx > trackRect.left) {
      final Rect activeRect = Rect.fromLTRB(
          trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
      final Paint activePaint = Paint()
        ..shader =
            gradient.createShader(trackRect) // Map gradient ตามความยาว track
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              activeRect, Radius.circular(trackRect.height)),
          activePaint);
    }
  }
}

// [เพิ่ม Class ใหม่] วาดปุ่มจับ (Thumb) เป็นวงแหวนไล่สี
class RingSliderThumbShape extends SliderComponentShape {
  final Gradient gradient;
  final double radius;
  final double ringThickness;

  const RingSliderThumbShape(
      {required this.gradient, this.radius = 10, this.ringThickness = 2.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    if (enableAnimation.value > 0) {
      // ถมสีขาวตรงกลาง
      canvas.drawCircle(
          center, radius - ringThickness, Paint()..color = Colors.white);

      // วาดขอบวงแหวน Gradient
      final Paint borderPaint = Paint()
        ..shader = gradient
            .createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringThickness * 1.5; // ปรับความหนาขอบ

      canvas.drawCircle(center, radius - (ringThickness / 2), borderPaint);
    }
  }
}
