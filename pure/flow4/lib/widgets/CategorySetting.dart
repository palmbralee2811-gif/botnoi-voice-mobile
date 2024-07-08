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
  double volumeValue = 50;
  double speedValue = 50;
  double _value = 1.0;
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 70,
                        child: Text(
                          'ความดัง',
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: Slider(
                        value: volumeValue,
                        inactiveColor: const Color(0xFFF7F8FA),
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: volumeValue.round().toString(),
                        onChanged: (value) =>
                            setState(() => volumeValue = value),
                      ),
                    ),
                    SizedBox(
                        width: 50,
                        child: Text('${volumeValue.round()}db',
                            style: GoogleFonts.prompt(
                              fontSize: 12.sp,
                            )))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 70,
                        child: Text(
                          'ความเร็ว',
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: GradientThumbShape(),
                            thumbColor: Colors.transparent,
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFF7F8FA)),
                        child: Slider(
                          value: _value,
                          min: 0,
                          max: 10,
                          onChanged: (newValue) {
                            setState(() {
                              _value = newValue;
                            });
                          },
                        ),
                        // value: speedValue,

                        // thumbColor: Colors.amber,
                        // activeColor: Colors.amber,
                        // inactiveColor: const Color(0xFFF7F8FA),
                        // min: 0,
                        // max: 100,
                        // divisions: 100,
                        // label: speedValue.round().toString(),
                        // onChanged: (value) =>
                        //     setState(() => speedValue = value),
                      ),
                    ),
                    SizedBox(
                        width: 50,
                        child: Text(
                          '${_value.round()} x',
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

// class GradientTrackShape extends SliderTrackShape {
//   @override
//   void paint(
    
//     PaintingContext context,
//     Offset offset, {
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required Animation<double> enableAnimation,
//     required TextDirection textDirection,
//     required Offset thumbCenter,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//     // required double additionalActiveTrackHeight,
//     // required double additionalInactiveTrackHeight,
//   }) {
//     final double trackHeight = sliderTheme.trackHeight ?? 2.0;
//     final Rect trackRect = Rect.fromLTWH(
//       offset.dx,
//       thumbCenter.dy - trackHeight / 2,
//       parentBox.size.width,
//       trackHeight,
//     );

//     final Paint activePaint = Paint()
//       ..shader = const  LinearGradient(
//         colors: <Color>[Colors.red, Colors.amber, Colors.green],
//       ).createShader(
//         Rect.fromLTWH(
//           offset.dx,
//           thumbCenter.dy - trackHeight / 2,
//           thumbCenter.dx - offset.dx,
//           trackHeight,
//         ),
//       );

//     final Paint inactivePaint = Paint()
//       ..color = Colors.grey;

//     // Draw the active track
//     context.canvas.drawRect(
//       Rect.fromLTWH(
//         offset.dx,
//         thumbCenter.dy - trackHeight / 2,
//         thumbCenter.dx - offset.dx,
//         trackHeight,
//       ),
//       activePaint,
//     );

//     // Draw the inactive track
//     context.canvas.drawRect(
//       Rect.fromLTWH(
//         thumbCenter.dx,
//         thumbCenter.dy - trackHeight / 2,
//         parentBox.size.width - thumbCenter.dx + offset.dx,
//         trackHeight,
//       ),
//       inactivePaint,
//     );
//   }
// }
class GradientThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(30.0, 30.0); // Size of the thumb
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
        Rect.fromCenter(center: center, width: 30.0, height: 30.0);
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFF9340FF), Color(0xFF34BDFA)],
      ).createShader(thumbRect)
      ..style = PaintingStyle.fill;

    context.canvas
        .drawCircle(center, 15.0, paint); // Radius is half of thumb size
  }
}
