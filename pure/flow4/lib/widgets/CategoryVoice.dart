import 'dart:ui';

import 'package:flow3/filter/language.dart';
import 'package:flow3/filter/recomman.dart';
import 'package:flow3/filter/sex.dart';
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

  @override
  Widget build(BuildContext context) {
    final data = AppDataBase.data;

    return InkWell(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                height: 245,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Language(),
                          const Sex(),
                          const Recommant(),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/logo/Category (4).png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 35,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/logo/Category (5).png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
                                                selectedIndex == index
                                                    ? ShaderMask(
                                                        shaderCallback:
                                                            (Rect bounds) {
                                                          return const LinearGradient(
                                                            colors: [
                                                              Color(0xFF9A96F5),
                                                              Color(0xFF00E0FF),
                                                            ],
                                                          ).createShader(
                                                              bounds);
                                                        },
                                                        child: SvgPicture.asset(
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
                                                      )
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

