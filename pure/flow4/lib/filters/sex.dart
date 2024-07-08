import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Sex extends StatelessWidget {
  const Sex({super.key});

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
                padding: const EdgeInsets.all(25),
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
                                'เพศ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
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
                                        'assets/logo/Category.jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'ชาย/หญิง',
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
                                        'assets/logo/Category (1).jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'หญิง',
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
                                        'assets/logo/Category (2).jpg',
                                        width: 50,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'ชาย',
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
                const SizedBox(
                  width: 3,
                ),
                Text('ช/ญ', style: GoogleFonts.prompt(fontSize: 12.sp)),
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
