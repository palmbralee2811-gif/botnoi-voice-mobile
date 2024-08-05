import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class DownloadPopup extends StatefulWidget {
  const DownloadPopup({super.key});

  @override
  State<DownloadPopup> createState() => _DownloadPopupState();
}

class _DownloadPopupState extends State<DownloadPopup> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160,
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: SizedBox(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  if (!isDone)
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1.0),
                      duration: const Duration(seconds: 5),
                      onEnd: () {
                        setState(() {
                          isDone = true;
                        });
                      },
                      builder: (context, value, child) => SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          value: value,
                          backgroundColor: const Color(0xFFF7F8FA),
                          strokeWidth: 5,
                        ),
                      ),
                    ),
                  if (!isDone)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GradientText(
                        'กำลังดาวน์โหลด',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: <Color>[
                              Color(0xFF9340FF),
                              Color(0xFF34BDFA),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GradientText(
                            'ดาวน์โหลดข้อมูลสำเร็จ',
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9340FF),
                                Color(0xFF34BDFA),
                              ],
                            ),
                            style: GoogleFonts.prompt(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
