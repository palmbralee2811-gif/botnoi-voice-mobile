import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/text_box_model.dart';
import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Modals/Delete/delete_modal.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/filter_section.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/gradient_shapes.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_button.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_icon.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.selectedLanguage = "TH",
    this.selectedLanguageImage = "assets/logo/Ellipse 12.jpg",
    this.selectedGender = "ช/ญ",
    this.selectedSpeakerId = "1",
    this.selectedVolume = 100,
    this.selectedSpeed = 100,
    this.workspaceId,
    this.textBoxIndex,
  });

  final String? workspaceId;
  final int? textBoxIndex;
  final String selectedLanguage;
  final String selectedLanguageImage;
  final String selectedGender;
  final String selectedSpeakerId;
  final double selectedVolume;
  final double selectedSpeed;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _textController = TextEditingController();

  final List<String> _favouriteSpeakerIds = [];
  final List<String> _selectedVoiceStyles = [];
  final List<String> _selectedSpeechStyles = [];
  String _selectedLanguage = "TH";
  String _selectedGender = "ช/ญ";
  String _selectedSpeakerId = embeddedSpeakerMetadata.first.speakerId;
  double _selectedVolume = 100;
  double _selectedSpeed = 100;

  bool _isFavouriteSelected = false;

  bool _isMainConfigOpen = false;
  bool _isExtraConfigOpen = false;

  bool _isTextEmpty = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    _selectedGender = widget.selectedGender;
    _selectedSpeakerId = widget.selectedSpeakerId;
    _selectedVolume = widget.selectedVolume;
    _selectedSpeed = widget.selectedSpeed;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSomeConfigOpen = _isMainConfigOpen || _isExtraConfigOpen;
    final int maxLinesWhenOpen = (404.h / 65.h).floor();
    final int maxLinesWhenClose = (404.h / 180.h).floor();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerAppbar(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 15.w),
              icon: Icon(
                Icons.menu_rounded,
                size: 32.sp,
                color: const Color(0xFF323130),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Colors.white,
        title: WorkspaceAppBarWidget(context),
      ),
      body: Column(
        children: [
          Container(
            width: 320.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: isSomeConfigOpen ? 196.h : 404.h,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 288.w,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 10.w, top: 20.h),
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: Colors.white,
                              style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                color: const Color(0xFF323130),
                              ),
                              minLines: isSomeConfigOpen
                                  ? maxLinesWhenClose
                                  : maxLinesWhenOpen,
                              maxLines: isSomeConfigOpen
                                  ? maxLinesWhenClose
                                  : maxLinesWhenOpen,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              onChanged: (text) {
                                if (_textController.text.length > 1000) {
                                  _textController.text =
                                      _textController.text.substring(0, 1000);
                                  _textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _textController.text.length,
                                    ),
                                  );
                                }
                                setState(() {
                                  _isTextEmpty =
                                      _textController.text.isNotEmpty;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA19F9D),
                                  fontStyle: GoogleFonts.prompt(fontSize: 14.sp)
                                      .fontStyle,
                                ),
                                hintMaxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _isTextEmpty
                                          ? const SizedBox()
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 1.w),
                                              child: InkWell(
                                                child: GradientIcon(
                                                  icon: Icons.close,
                                                  size: 20.sp,
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF9340FF),
                                                      Color(0xFF34BDFA)
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GradientText(
                                        _textController.text.length.toString(),
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          color: const Color(0xFFA19F9D),
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF9340FF),
                                            Color(0xFF34BDFA)
                                          ],
                                        ),
                                      ),
                                      Text(
                                        ' / 1000',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          color: const Color(0xFFA19F9D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: 261.h,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isMainConfigOpen = !_isMainConfigOpen;
                        if (_isMainConfigOpen) {
                          _isExtraConfigOpen = false;
                        }
                      });
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFE2E3E9),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "เลือกเสียง",
                              style: GoogleFonts.prompt(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF323130),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: _isMainConfigOpen
                                ? Icon(
                                    Icons.expand_less,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.expand_more,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isMainConfigOpen) _buildMainConfigBar(context),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExtraConfigOpen = !_isExtraConfigOpen;
                        if (_isExtraConfigOpen) {
                          _isMainConfigOpen = false;
                        }
                      });
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFE2E3E9),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "ตั้งค่าเพิ่มเติม",
                              style: GoogleFonts.prompt(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF323130),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: _isExtraConfigOpen
                                ? Icon(
                                    Icons.expand_less,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.expand_more,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExtraConfigOpen) _buildExtraConfigBar(context),
                  Expanded(
                    child: _buildGenerateVoiceButton(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainConfigBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilterSection(
          selectedGender: _selectedGender,
          selectedLanguage: _selectedLanguage,
          selectedVoiceStyles: _selectedVoiceStyles,
          selectedSpeechStyles: _selectedSpeechStyles,
          isFavouriteSelected: _isFavouriteSelected,
          onGenderSelected: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          onLanguageSelected: (value) {
            setState(() {
              _selectedLanguage = value;
            });
          },
          onVoiceStyleSelected: (value) {
            setState(() {
              if (_selectedVoiceStyles.contains(value)) {
                _selectedVoiceStyles.remove(value);
              } else {
                _selectedVoiceStyles.add(value);
              }
            });
          },
          onSpeechStyleSelected: (value) {
            setState(() {
              if (_selectedSpeechStyles.contains(value)) {
                _selectedSpeechStyles.remove(value);
              } else {
                _selectedSpeechStyles.add(value);
              }
            });
          },
          onFavouriteSelected: (value) {
            setState(() {
              _isFavouriteSelected = value;
            });
          },
        ),
        _buildSpeakerRow(context),
      ],
    );
  }

  Widget _buildExtraConfigBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 142.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 20.h,
              right: 10.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up,
                        color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                      width: 46.w,
                      child: Text(
                        'ความดัง',
                        style: GoogleFonts.prompt(fontSize: 12.sp),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: GradientSliderShape(),
                          thumbColor: Colors.transparent,
                          trackShape:
                              const GradeintRoundedRectSliderTrackShape(),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFF7F8FA),
                        ),
                        child: Slider(
                          value: _selectedVolume,
                          min: 0,
                          max: 100,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedVolume = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55.w,
                      child: Text(
                        '${_selectedVolume.toStringAsFixed(1)}%',
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.speed,
                        color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                      width: 46.w,
                      child: Text(
                        'ความเร็ว', //speed
                        style: GoogleFonts.prompt(fontSize: 12.sp),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: GradientSliderShape(),
                          thumbColor: Colors.transparent,
                          trackShape:
                              const GradeintRoundedRectSliderTrackShape(),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFF7F8FA),
                        ),
                        child: Slider(
                          value: _selectedSpeed,
                          min: 0.2,
                          max: 2.0,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSpeed = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      '${_selectedSpeed.toStringAsFixed(1)} x',
                      style: GoogleFonts.prompt(fontSize: 12.sp),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerCard(SpeakerMetadataModel speakerMetadata) {
    return GestureDetector(
      onTap: () async {
        if (_audioPlayer.state == PlayerState.playing) {
          await _audioPlayer.stop();
        }
        if (speakerMetadata.audio.isNotEmpty) {
          await _audioPlayer.play(UrlSource(speakerMetadata.audio));
          _audioPlayer.onPlayerComplete.listen((event) {});
        }
        setState(() {
          _selectedSpeakerId = speakerMetadata.speakerId;
        });
      },
      child: Container(
        width: 81.w,
        height: 103.h,
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            width: 3.w,
            gradient: _selectedSpeakerId == speakerMetadata.speakerId
                ? const LinearGradient(
                    colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                  )
                : LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                    begin: const Alignment(1, 1),
                  ),
          ),
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: NetworkImage(
              speakerMetadata.squareImage,
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: _selectedSpeakerId == speakerMetadata.speakerId
              ? [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: const Color(0xFF9340FF).withOpacity(0.6),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Container(
          width: 100.w,
          height: 113.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            gradient: LinearGradient(
              begin: const Alignment(1, 1),
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 5.w,
                      top: 5.h,
                      left: 5.w,
                    ),
                    child: _selectedSpeakerId == speakerMetadata.speakerId
                        ? Container(
                            width: 31.w,
                            height: 17.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                'เลือก',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: GoogleFonts.prompt().fontStyle,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, top: 5.h),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_favouriteSpeakerIds
                              .contains(speakerMetadata.speakerId)) {
                            _favouriteSpeakerIds
                                .remove(speakerMetadata.speakerId);
                          } else {
                            _favouriteSpeakerIds.add(speakerMetadata.speakerId);
                          }
                        });
                      },
                      child: _favouriteSpeakerIds
                              .contains(speakerMetadata.speakerId)
                          ? ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFF9A96F5),
                                    Color(0xFF00E0FF),
                                  ],
                                ).createShader(bounds);
                              },
                              child: SvgPicture.asset(
                                'assets/logo/heart (1).svg',
                                width: 20.w,
                                height: 20.h,
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/logo/heart.svg',
                              width: 20.w,
                              height: 20.h,
                            ),
                    ),
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  _selectedSpeakerId == speakerMetadata.speakerId
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFF9A96F5),
                                Color(0xFF00E0FF),
                              ],
                            ).createShader(bounds);
                          },
                          child: SvgPicture.asset(
                            'assets/logo/Vector.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/logo/Vector (1).svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: Text(
                      speakerMetadata.thaiName,
                      style: GoogleFonts.prompt(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakerRow(BuildContext context) {
    List<SpeakerMetadataModel> speakersToShow =
        List.from(embeddedSpeakerMetadata);
    if (_isFavouriteSelected) {
      speakersToShow = embeddedSpeakerMetadata
          .where((speaker) => _favouriteSpeakerIds.contains(speaker.speakerId))
          .toList();
    }
    if (_selectedGender.isNotEmpty && _selectedGender != "ช/ญ") {
      speakersToShow = speakersToShow
          .where((speaker) => speaker.gender.contains(_selectedGender))
          .toList();
    }
    if (_selectedVoiceStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => _selectedVoiceStyles.contains(speaker.voiceStyle),
          )
          .toList();
    }
    if (_selectedSpeechStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.speechStyle.any(
              (speechStyle) => _selectedSpeechStyles.contains(speechStyle),
            ),
          )
          .toList();
    }
    if (_selectedLanguage.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.language.contains(_selectedLanguage),
          )
          .toList();
    }

    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: ListView.builder(
        itemCount: speakersToShow.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: _buildSpeakerCard(
              speakersToShow[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenerateVoiceButton(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding:
              EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              setState(() {
                _audioPlayer.stop();
              });

              if (_textController.text.isEmpty) {
                // TODO: Show error message
                return;
              }
              if (_selectedSpeakerId.isEmpty) {
                // TODO: Show error message
                return;
              }

              String? generatedAudioUrl = await Provider.of<MainServerProvider>(
                context,
                listen: false,
              ).generateAudio(
                _textController.text,
                _selectedSpeakerId,
                _selectedVolume.toInt(),
                _selectedSpeed.toInt(),
              );

              if (generatedAudioUrl?.isNotEmpty ?? false) {
                TextBoxModel textBox = TextBoxModel(
                  text: _textController.text,
                  speaker: int.tryParse(_selectedSpeakerId) ?? 1,
                  audioId: _randomString(5),
                  speed: _selectedSpeed.toString(),
                  statusDownload: true,
                  url: generatedAudioUrl!,
                  volume: _selectedVolume.toString(),
                );

                if (widget.workspaceId == null) {
                  String? workspaceId = await Provider.of<MainServerProvider>(
                    context,
                    listen: false,
                  ).createWorkspace(
                    name: "New Workspace",
                  );
                  if (workspaceId != null) {
                    await Provider.of<MainServerProvider>(
                      context,
                      listen: false,
                    ).createTextBox(
                      workspaceId: workspaceId,
                      textBox: textBox,
                    );
                  }
                } else if (widget.workspaceId != null &&
                    widget.textBoxIndex == null) {
                  await Provider.of<MainServerProvider>(
                    context,
                    listen: false,
                  ).createTextBox(
                    workspaceId: widget.workspaceId!,
                    textBox: textBox,
                  );
                } else {
                  await Provider.of<MainServerProvider>(
                    context,
                    listen: false,
                  ).updateTextBox(
                    workspaceId: widget.workspaceId!,
                    textBoxIndex: widget.textBoxIndex!,
                    updatedTextBox: textBox,
                  );
                }
                if (mounted) {
                  //TODO: Go to the work space screen
                  //Navigator.pushReplacement(
                  //  context,
                  //  MaterialPageRoute(
                  //    builder: (context) => const WorkspaceScreen(),
                  //  ),
                  //);
                }
              } else {
                //TODO: Show error message
              }
            },
          ),
        ),
      ],
    );
  }

  /// Generate a random string
  String _randomString(int length) {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(
          random.nextInt(characters.length),
        ),
      ),
    );
  }
}
