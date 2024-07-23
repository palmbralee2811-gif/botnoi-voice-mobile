/*
  Widget categoryVoice(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    // var screenSize = MediaQuery.of(context).size;
    
    return FutureBuilder<List<Speaker>>(
      future: _fetchMarketplaceDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {  
          // Render your data here
          List<Speaker> speakers = snapshot.data!;
          speakers.sort((a, b) => int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));
              
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /*
                            Language(),
                            Sex(),
                            Recommant(),
                            Favorite(),
                            All(),
                            New(),
                            Voice(),
                            Advert(),
                            Podcast(),
                            */
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
                            width: screenSizewidth * 0.90,
                            child: GridView.builder(
                              itemCount: speakers.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 110,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Speaker speaker = speakers[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/alisa/sound_1_alisa.wav
                                        String? audioURL = speaker.audio;

                                        Future<void> playAudio() async {
                                          if (audioURL.isNotEmpty) {
                                            if (isAudioPlaying) {
                                              // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
                                              await audioPlayer.stop();
                                            }

                                            await audioPlayer
                                                .play(UrlSource(audioURL));
                                            setState(() {
                                              isAudioPlaying = true;
                                            });

                                            audioPlayer.onPlayerComplete
                                                .listen((event) {
                                              print(
                                                  "#### Play Audio's Complete");
                                              setState(() {
                                                isAudioPlaying = false;
                                              });
                                            });
                                          } else {
                                            setState(() {
                                              isAudioPlaying = false;
                                            });
                                            print(
                                                "Audio URL is empty, cannot play audio");
                                          }
                                        }

                                        await playAudio();

                                        // get data in value to the generate audio function
                                        speakerId = speaker.speakerId;
                                        availableLanguage = speaker.availableLanguage.toList();
                                        language = speaker.language.toLowerCase();

                                        print(
                                            '\nspeakerId -> Widget(DataVoice): $speakerId');
                                        print(
                                            'squareImage -> Widget(DataVoice): ${speaker.squareImage}');
                                        print(
                                            'thaiName -> Widget(DataVoice): ${speaker.thaiName}');
                                        print(
                                            'engName -> Widget(DataVoice): ${speaker.engName}');
                                        print(
                                            'language -> Widget(DataVoice): ${speaker.language.toLowerCase()}');
                                        print(
                                            'availableLanguage -> Widget(DataVoice): ${speaker.availableLanguage.toList()} \n');
                                        setState(() {});

                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        width: screenSizewidth * 0.9,
                                        height: screenSizeheight * 0.180,
                                        decoration: BoxDecoration(
                                          border: GradientBoxBorder(
                                            // width: screenSizeheight * 0.01,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                speaker.squareImage),
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 39.w,
                                                                top: 8.w),
                                                        child:
                                                            selectedIndex ==
                                                                    index
                                                                ? Container(
                                                                    width: 21.w,
                                                                    height:
                                                                        17.h,
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
                                                                          BorderRadius.circular(
                                                                              8.r),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          'เลือก',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                7.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    ),
                                                                  )
                                                                : const Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                      ),
                                                      /*
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedIndex2 =
                                                                  index;
                                                            });
                                                          },
                                                          child:
                                                              selectedIndex2 ==
                                                                      index
                                                                  ? ShaderMask(
                                                                      shaderCallback:
                                                                          (Rect
                                                                              bounds) {
                                                                        return const LinearGradient(
                                                                          colors: [
                                                                            Color(0xFF9A96F5),
                                                                            Color(0xFF00E0FF),
                                                                          ],
                                                                        ).createShader(
                                                                            bounds);
                                                                      },
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/logo/heart (1).svg',
                                                                        width:
                                                                            10.w,
                                                                        height:
                                                                            10.h,
                                                                        color: Colors
                                                                            .white, // Optional: Default color of the SVG
                                                                      ),
                                                                    )
                                                                  : SvgPicture
                                                                      .asset(
                                                                      'assets/logo/heart.svg',
                                                                      width:
                                                                          12.sp,
                                                                      height:
                                                                          12.sp,
                                                                    ))
                                                                    */
                                                    ]),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 6.w,
                                                      right: 6.w,
                                                      top: 45.w),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        selectedIndex == index
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
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
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
                                                          speaker.thaiName,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
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
    );
  }
*/