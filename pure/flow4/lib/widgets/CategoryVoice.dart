import 'dart:ui';

import 'package:flow3/filters/advert.dart';
import 'package:flow3/filters/all.dart';
import 'package:flow3/filters/favorite.dart';
import 'package:flow3/filters/language.dart';
import 'package:flow3/filters/new.dart';
import 'package:flow3/filters/podcast.dart';
import 'package:flow3/filters/recomman.dart';
import 'package:flow3/filters/sex.dart';
import 'package:flow3/filters/voice.dart';
import 'package:flutter/material.dart';
import 'package:flow3/data/data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:flow3/widgets/story_viewer.dart';

class CategoryVoice extends StatefulWidget {
  const CategoryVoice({Key? key}) : super(key: key);

  @override
  _CategoryVoiceState createState() => _CategoryVoiceState();
}

class _CategoryVoiceState extends State<CategoryVoice> {
  int selectedIndex = -1;
  int selectedIndex2 = -1;

  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    // var screenSize = MediaQuery.of(context).size;
    final data = AppDataBase.data;

    return InkWell(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenSizeheight * 0.05.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      color: const Color(0xFFFFFFFF),
                      width: 600.w,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Language(),
                            Sex(),
                            Recommand(),
                            Favorite(),
                            All(),
                            New(),
                            Voice(),
                            Advert(),
                            Podcast(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFFFFFFFF),
                height: screenSizeheight * 0.175.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screenSizeheight * 0.165.h,
                      width: screenSizewidth * 0.95.w,
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 120,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    //////////
                                  },
                                  child: Container(
                                    width: screenSizewidth * 0.9.w,
                                    height: screenSizeheight * 0.145.h,
                                    decoration: BoxDecoration(
                                      border: GradientBoxBorder(
                                        width: 3.h,
                                        gradient: selectedIndex == index
                                            ? const LinearGradient(colors: [
                                                Color(0xFF9A96F5),
                                                Color(0xFF00E0FF)
                                              ])
                                            : const LinearGradient(colors: [
                                                Colors.transparent,
                                                Colors.transparent
                                              ]),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(
                                        image: AssetImage(data[index].image),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedIndex == index
                                              ? Colors.blue.withOpacity(0.5)
                                              : Colors.transparent,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20.w, top: 4.w),
                                                    child:
                                                        selectedIndex == index
                                                            ? Container(
                                                                width: 31.w,
                                                                height: 17.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFF9A96F5),
                                                                      Color(
                                                                          0xFF00E0FF)
                                                                    ],
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      'เลือก',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontStyle:
                                                                            GoogleFonts.prompt(
                                                                          fontSize:
                                                                              10.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ).fontStyle,
                                                                      )),
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex2 =
                                                              index;
                                                        });
                                                      },
                                                      child: selectedIndex2 ==
                                                              index
                                                          ? ShaderMask(
                                                              shaderCallback:
                                                                  (Rect
                                                                      bounds) {
                                                                return const LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xFF9A96F5),
                                                                    Color(
                                                                        0xFF00E0FF),
                                                                  ],
                                                                ).createShader(
                                                                    bounds);
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/logo/heart (1).svg',
                                                                width: 16.w,
                                                                height: 16.h,
                                                                color: Colors
                                                                    .white, // Optional: Default color of the SVG
                                                              ),
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/logo/heart.svg',
                                                              width: 16.sp,
                                                              height: 16.sp,
                                                            ))
                                                ]),
                                            SizedBox(
                                              height: screenSizeheight * 0.07.h,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  selectedIndex == index
                                                      ? ShaderMask(
                                                          shaderCallback:
                                                              (Rect bounds) {
                                                            return const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF9A96F5),
                                                                Color(
                                                                    0xFF00E0FF),
                                                              ],
                                                            ).createShader(
                                                                bounds);
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/logo/Vector.svg',
                                                            width:
                                                                screenSizeheight *
                                                                    0.03.h,
                                                            height:
                                                                screenSizeheight *
                                                                    0.02.h,
                                                            color: Colors
                                                                .white, // Optional: Default color of the SVG
                                                          ),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/logo/Vector (1).svg',
                                                          width:
                                                              screenSizeheight *
                                                                  0.01.h,
                                                          height:
                                                              screenSizeheight *
                                                                  0.02.h,
                                                        ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Text(
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: null,
                                                    data[index].name,
                                                    style: GoogleFonts.prompt(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ])
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 1.w,
                              // ),
                              // SizedBox(
                              //   width: screenSizewidth * 0
                              //     ..w,
                              // ),
                              // SizedBox(
                              //   width: 3.w,
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
