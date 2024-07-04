import 'dart:ui';

import 'package:flow3/filter/advert.dart';
import 'package:flow3/filter/all.dart';
import 'package:flow3/filter/favorite.dart';
import 'package:flow3/filter/language.dart';
import 'package:flow3/filter/new.dart';
import 'package:flow3/filter/podcast.dart';
import 'package:flow3/filter/recomman.dart';
import 'package:flow3/filter/sex.dart';
import 'package:flow3/widgets/voice.dart';
import 'package:flutter/material.dart';
import 'package:flow3/data/data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                height: screenSizeheight * 0.04,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      width: 500.w,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Language(),
                            Sex(),
                            Recommant(),
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
                color: Colors.white,
                height: screenSizeheight * 0.196,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screenSizeheight * 0.195,
                      width: screenSizewidth*0.90,
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 110,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  width: screenSizewidth * 0.9,
                                  height: screenSizeheight * 0.180,
                                  decoration: BoxDecoration(
                                    border: GradientBoxBorder(
                                      width: screenSizeheight * 0.01,
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
                                    borderRadius: BorderRadius.circular(10),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                  padding:
                                                      EdgeInsets.only(
                                                          right: 39.w, top: 8.w),
                                                  child: selectedIndex == index
                                                      ? Container(
                                                          width: 21.w,
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
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Text('เลือก',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 7.sp,
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
                                                        selectedIndex2 = index;
                                                      });
                                                    },
                                                    child: selectedIndex2 ==
                                                            index
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
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/logo/heart (1).svg',
                                                              width: 10.w,
                                                              height: 10.h,
                                                              color: Colors
                                                                  .white, // Optional: Default color of the SVG
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            'assets/logo/heart.svg',
                                                            width: 12.sp,
                                                            height: 12.sp,
                                                          ))
                                              ]),
                                          Padding(
                                            padding:  EdgeInsets.only(
                                                left: 8.w, right: 8.w, top: 45.w),
                                            child: Row(
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
                                                            width: 10.sp,
                                                            height: 10.sp,
                                                            color: Colors
                                                                .white, // Optional: Default color of the SVG
                                                          ),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/logo/Vector.svg',
                                                        ),
                                                  Text(
                                                    data[index].name,
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
