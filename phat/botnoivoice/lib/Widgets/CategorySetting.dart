import 'package:botnoivoice/Filters/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//
class CategorySetting extends StatefulWidget {
  const CategorySetting({Key? key}) : super(key: key);

  @override
  _CategorySettingState createState() => _CategorySettingState();
}

class _CategorySettingState extends State<CategorySetting> {
  double speedValue = 1.0; // ความเร็ว
  double _volumevalue = 100; // ความดัง
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.transparent,
          height: screenSize.height * 0.200.h,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.w,
              right: 10.w,
              left: 20.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Language(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up, color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                        width: 46.w,
                        child: Text(
                          'ความดัง',
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: GradientThumbShape(),
                            thumbColor: Colors.transparent,
                            trackShape:
                                const GradeintRoundedRectSliderTrackShape(),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFF7F8FA)),
                        child: Slider(
                          value: _volumevalue,
                          min: 0,
                          max: 100,
                          onChanged: (newValue) {
                            setState(() {
                              _volumevalue = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 55,
                        child: Text('${_volumevalue.toStringAsFixed(1)}%',
                            style: GoogleFonts.prompt(
                              fontSize: 12.sp,
                            )))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.speed, color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                        width: 46.w,
                        child: Text(
                          'ความเร็ว', //speed
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: GradientThumbShape(),
                            thumbColor: Colors.transparent,
                            trackShape:
                                const GradeintRoundedRectSliderTrackShape(),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFF7F8FA)),
                        child: Slider(
                          value: speedValue,
                          min: 0.2,
                          max: 2.0,
                          onChanged: (newValue) {
                            setState(() {
                              speedValue = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 55,
                        child: Text(
                          '${speedValue.toStringAsFixed(1)} x',
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(16.0, 16.0); // Size of the thumb
  }

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
    final Rect thumbRect =
        Rect.fromCenter(center: center, width: 20.0, height: 30.0);
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFF9340FF), Color(0xFF34BDFA)],
      ).createShader(thumbRect)
      ..style = PaintingStyle.fill;

    context.canvas
        .drawCircle(center, 15.0, paint); // Radius is half of thumb size
  }
}

class GradeintRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const GradeintRoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    LinearGradient gradeinet = const LinearGradient(
      colors: <Color>[Color(0xFF9340FF), Color(0xFF34BDFA)],
    );

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradeinet.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final (Paint leftTrackPaint, Paint rightTrackPaint) =
        switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
          begin: sliderTheme.disabledSecondaryActiveTrackColor,
          end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (textDirection == TextDirection.ltr) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}
