import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) => Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: 360,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ภาษา',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Thai(Thailand) - ไทย',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'English (UK) - อังกฤษ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Indonesia - อินโดนีเซีย',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Japanese - ญี่ปุ่น',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Laos - ลาว',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Myanmar - เมียนมาร์',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Vietnam - เวียดนาม',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
                            height: 42,
                            width: 320,
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Ellipse 12.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Chinese (Simplified) - จีน',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      child: Container(
        width: 62.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/Ellipse 12.jpg',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 3,),
                Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 20,
                  color: Color(0xFF323130),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
