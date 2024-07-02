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
    var screenSize = MediaQuery.of(context).size;
    final data = AppDataBase.data;

    return InkWell(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: screenSize.height * 0.04,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: 600,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Language(),
                            Sex(),
                            Recommant(),
                            Favorite(),
                            All(),
                            New(),
                            Voice(),
                            const Advert(),
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
                height: screenSize.height * 0.196,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 170,
                      width: 370,
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
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: GradientBoxBorder(
                                      width: 4,
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
                                                      const EdgeInsets.only(
                                                          right: 45, top: 5),
                                                  child: selectedIndex == index
                                                      ? Container(
                                                          width: 31,
                                                          height: 17,
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
                                                                        10),
                                                          ),
                                                          child: const Center(
                                                            child: Text('เลือก',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
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
                                                              width: 16,
                                                              height: 16,
                                                              color: Colors
                                                                  .white, // Optional: Default color of the SVG
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            'assets/logo/heart.svg',
                                                            width: 16,
                                                            height: 16,
                                                          ))
                                              ]),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 89),
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
                                                            width: 16,
                                                            height: 16,
                                                            color: Colors
                                                                .white, // Optional: Default color of the SVG
                                                          ),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/logo/Vector.svg',
                                                        ),
                                                  Text(
                                                    data[index].name,
                                                    style: const TextStyle(
                                                      fontSize: 15,
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
