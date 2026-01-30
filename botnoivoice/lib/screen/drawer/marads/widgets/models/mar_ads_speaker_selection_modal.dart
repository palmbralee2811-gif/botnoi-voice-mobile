import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_filter_modal_sheet.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_grid_item.dart';
import 'package:botnoivoice/service/favorite/favorite_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class MarAdsSpeakerSelectionModal extends ConsumerStatefulWidget {
  final Function(SpeakerEntity) onSelect;
  final SpeakerEntity? selectedSpeaker;

  const MarAdsSpeakerSelectionModal({
    super.key,
    required this.onSelect,
    this.selectedSpeaker,
  });

  @override
  ConsumerState<MarAdsSpeakerSelectionModal> createState() =>
      _MarAdsSpeakerSelectionModalState();
}

class _MarAdsSpeakerSelectionModalState
    extends ConsumerState<MarAdsSpeakerSelectionModal> {
  final Logger _logger = Logger();
  List<String> _favoriteIds = [];
  bool _isLoadingFav = true;

  //   ตัวแปรสำหรับ Search และ Audio
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  SpeakerEntity? _tempSelectedSpeaker; // ตัวที่กำลังเลือกอยู่ (ยังไม่กดตกลง)
  bool _showOnlyFavorites = false; // สถานะกรองเฉพาะรายการโปรด

  late String _selectedLangCode;
  late String _selectedLangName;
  late String _selectedLangImage;
  String _selectedGender = ''; // ว่าง = ทั้งหมด
  late String _selectedGenderName;
  Set<String> _selectedStyles = {}; // เก็บ Style ที่เลือก
  Set<String> _selectedCategories = {};
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    // ตั้งค่าตัวเลือกเริ่มต้น
    _tempSelectedSpeaker = widget.selectedSpeaker;

    //ลองเก็บก่อนเผื่อ Speaker ค้างอยู่ที่ V1
    // // Set ค่าเริ่มต้น Filter ตาม Speaker ที่ส่งเข้ามา (ถ้ามี)
    // if (widget.selectedSpeaker != null) {
    //   _selectedLangCode = widget.selectedSpeaker!.languageCode.isEmpty
    //       ? 'TH'
    //       : widget.selectedSpeaker!.languageCode.toUpperCase();
    //   // หาชื่อและรูปภาษาจาก List
    //   final langData = languageFilter.firstWhere(
    //     (l) => l['code'] == _selectedLangCode,
    //     orElse: () => languageFilter[0],
    //   );
    //   _selectedLangName = langData['thaiName'] as String;
    //   _selectedLangImage = langData['image'] as String;
    // }

    _loadFavorites();
    _searchController.addListener(() {
      setState(() {}); // รีเฟรชหน้าจอเมื่อพิมพ์ค้นหา
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // ดึงค่าเริ่มต้นตาม Locale ของแอป
      _selectedLangCode = tr('default_language_filter_code');
      _selectedLangName = tr('default_language_filter_name');
      _selectedLangImage = tr('default_language_filter_image_path');
      _selectedGenderName = 'male_female'.tr();
      _isInit = true;
    }
  }

  //   Dispose Player และ Controller
  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final token = ref.read(currentUserTokenStateProvider).jwtToken;
      if (token != null && token.isNotEmpty) {
        final service = FavoriteService();
        final favs = await service.getFavoriteSpeakers(token);
        if (mounted) {
          setState(() {
            _favoriteIds = favs;
            _isLoadingFav = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingFav = false);
      }
    } catch (e) {
      _logger.e("Error loading favorites in MarAds: $e");
      if (mounted) setState(() => _isLoadingFav = false);
    }
  }

  Future<void> _toggleFavorite(String speakerId) async {
    final token = ref.read(currentUserTokenStateProvider).jwtToken;
    if (token == null || token.isEmpty) return;

    final service = FavoriteService();
    final isFav = _favoriteIds.contains(speakerId);

    setState(() {
      if (isFav) {
        _favoriteIds.remove(speakerId);
      } else {
        _favoriteIds.add(speakerId);
      }
    });

    try {
      if (isFav) {
        await service.removeFavoriteSpeaker(speakerId, token);
      } else {
        await service.saveFavoriteSpeakers(_favoriteIds, token);
      }
    } catch (e) {
      _logger.e("Error toggle favorite: $e");
      if (mounted) {
        setState(() {
          if (isFav) {
            _favoriteIds.add(speakerId);
          } else {
            _favoriteIds.remove(speakerId);
          }
        });
      }
    }
  }

  //   ฟังก์ชันเล่นเสียง (จำลองจาก speaker_tap_handler.dart)
  Future<void> _playAudio(String audioUrl) async {
    try {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
      }

      // ใช้ http.get เพื่อรองรับ Header/Referer ตามไฟล์ตัวอย่าง
      final response = await http.get(
        Uri.parse(audioUrl),
        headers: {'Referer': 'https://voice.botnoi.ai/'},
      );

      if (response.statusCode == 200) {
        final audioBytes = response.bodyBytes;
        if (audioBytes.isNotEmpty) {
          final mimeType = response.headers['content-type'] ?? 'audio/wav';
          await _audioPlayer.play(
            BytesSource(audioBytes, mimeType: mimeType),
          );
        }
      }
    } catch (e) {
      _logger.e("Error playing audio: $e");
    }
  }

  void _showFilterModal() async {
    // เปิด Modal และรอรับค่ากลับ (result)
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return MarAdsFilterModalSheet(
          initialLangCode: _selectedLangCode,
          initialLangName: _selectedLangName,
          initialLangImage: _selectedLangImage,
          initialGender: _selectedGender,
          initialCategories: _selectedCategories,
          initialStyles: _selectedStyles,
        );
      },
    );

    // ถ้ามีการกดดูผลลัพธ์ (result ไม่เป็น null) ให้อัปเดตค่า
    if (result != null) {
      setState(() {
        _selectedLangCode = result['langCode'];
        _selectedLangName = result['langName'];
        _selectedLangImage = result['langImage'];
        _selectedGender = result['gender'];
        _selectedCategories = result['categories'];
        _selectedStyles = result['styles'];
      });
    }
  }

  List<SpeakerEntity> _getFilteredSpeakers() {
    return SpeakerModel.speakerItem.where((s) {
      if (!s.status) return false;

      // Favorites
      if (_showOnlyFavorites && !_favoriteIds.contains(s.speakerId)) {
        return false;
      }

      // Language
      final sLang = s.languageCode.toUpperCase();
      final sLangName = s.language.toUpperCase();
      if (sLang != _selectedLangCode && sLangName != _selectedLangCode) {
        return false;
      }

      // Gender
      if (_selectedGender.isNotEmpty && s.gender != _selectedGender) {
        return false;
      }

      // Categories
      if (_selectedCategories.isNotEmpty) {
        final isAppThai = context.locale.languageCode == 'th';

        final List<String> speakerCats = isAppThai
            ? s.speechStyle
            : (s.engSpeechStyle.isNotEmpty ? s.engSpeechStyle : s.speechStyle);

        if (!speakerCats.any((c) => _selectedCategories.contains(c))) {
          return false;
        }
      }

      // Styles
      if (_selectedStyles.isNotEmpty) {
        final isAppThai = context.locale.languageCode == 'th';

        final List<String> speakerStyles = isAppThai
            ? s.voiceStyle
            : (s.engVoiceStyle.isNotEmpty ? s.engVoiceStyle : s.voiceStyle);

        if (!speakerStyles.any((st) => _selectedStyles.contains(st)))
          return false;
      }

      // Search Text
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        return s.thaiName.toLowerCase().contains(query) ||
            s.engName.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    final filteredSpeakers = _getFilteredSpeakers();

    return Container(
      height: MediaQuery.of(context).size.height *
          0.85, // ปรับความสูงให้เกือบเต็มจอ
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ปุ่มย้อนกลับ และ ชื่อหน้า
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'style'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),

            SizedBox(height: 12.h),

            // Search Bar และ Filter Icons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.prompt(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'select'.tr(),
                        hintStyle: GoogleFonts.prompt(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // ปุ่ม Filter (Mockup: ในอนาคตอาจเปิด Modal เลือกภาษา/เพศ)
                GestureDetector(
                  onTap: _showFilterModal, // เรียกฟังก์ชันเปิด Modal
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      // เปลี่ยนสีไอคอนถ้ามีการ Filter อยู่ (ยกเว้นภาษาที่เป็น Default)
                      color: (_selectedGender.isNotEmpty ||
                              _selectedStyles.isNotEmpty ||
                              _selectedCategories.isNotEmpty)
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.tune, color: Colors.black, size: 24.sp),
                  ),
                ),
                SizedBox(width: 10.w),
                // ปุ่ม Heart Filter (กรองเฉพาะรายการโปรด)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showOnlyFavorites = !_showOnlyFavorites;
                    });
                  },
                  child: Icon(
                    _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
                    color: _showOnlyFavorites ? Colors.red : Colors.grey,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Expanded(
              child: _isLoadingFav
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: filteredSpeakers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 11.h,
                      ),
                      itemBuilder: (context, index) {
                        final speaker = filteredSpeakers[index];

                        // เช็คกับ _tempSelectedSpeaker (ตัวที่จิ้มล่าสุด)
                        final isSelected = speaker.speakerId.trim() ==
                            _tempSelectedSpeaker?.speakerId.trim();
                        final isFavorite =
                            _favoriteIds.contains(speaker.speakerId);

                        return SpeakerGridItem(
                          key: ValueKey(speaker.speakerId),
                          speakerItem: speaker,
                          index: index,
                          isSelected: isSelected,
                          isFavorite: isFavorite,
                          onSpeakerTap: (idx, item) {
                            _logger.d(
                                "Tapped: ${item.thaiName} (ID: ${item.speakerId})");
                            // เช็คว่าถ้ากดตัวเดิม ให้ Unselect (ยกเลิกการเลือก)
                            if (_tempSelectedSpeaker?.speakerId.trim() ==
                                item.speakerId.trim()) {
                              _audioPlayer.stop(); // หยุดเล่นเสียง
                              setState(() {
                                _tempSelectedSpeaker = null;
                              });
                            } else {
                              _playAudio(item.audio);
                              setState(() {
                                _tempSelectedSpeaker = item;
                              });
                            }
                          },
                          onFavoriteToggle: (id) => _toggleFavorite(id),
                        );
                      },
                    ),
            ),

            // ปุ่ม "ตกลง" ด้านล่าง
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _tempSelectedSpeaker != null
                    ? () {
                        widget.onSelect(_tempSelectedSpeaker!);
                        context.pop();
                      }
                    : null, // ปิดปุ่มถ้ายังไม่เลือก
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF262626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  'confirm'.tr(),
                  style: GoogleFonts.prompt(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h), // Safe area
          ],
        ),
      ),
    );
  }
}
