import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Sex extends StatefulWidget {
  const Sex({super.key});

  @override
  State<Sex> createState() => _SexState();
}

class _SexState extends State<Sex> {
  String selectedGender = 'M/F';
  bool changeIcon = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          changeIcon = !changeIcon;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SizedBox(
                  height: 220.h,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: 280.w,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sex',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 24.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedGender = 'M/F';
                                  });
                                  setState(() {
                                    changeIcon = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.w),
                                  height: 42.h,
                                  width: 320.w,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Category.jpg',
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        'M/F',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          fontWeight: selectedGender == 'M/F'
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedGender = 'Female';
                                  });
                                  setState(() {
                                    changeIcon = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.w),
                                  height: 42.h,
                                  width: 320.w,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Category (1).jpg',
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        'Female',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          fontWeight: selectedGender == 'Female'
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedGender = 'Man';
                                  });
                                  setState(() {
                                    changeIcon = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.w),
                                  height: 42.h,
                                  width: 320.w,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/logo/Category (2).jpg',
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        'Man',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          fontWeight: selectedGender == 'Man'
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          setState(() {
            changeIcon = false;
          });
        });
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
                Text(selectedGender,
                    style: GoogleFonts.prompt(fontSize: 12.sp)),
                changeIcon
                    ? const Icon(
                        Icons.keyboard_arrow_up_sharp,
                        size: 20,
                        color: Color(0xFF323130),
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 20,
                        color: Color(0xFF323130),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
