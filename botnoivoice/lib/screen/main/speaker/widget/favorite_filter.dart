import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class FavoriteFilter extends StatelessWidget {
  final List<String> selectedIndexFavorites;
  final Set<int> selectedIndex;
  final Function(int index, SpeakerEntity speaker) onSpeakerTap;
  final Function(String speakerId) onFavoriteToggle;
  final String currentLanguage;
  final Set<String> currentCategories;
  final Set<String> currentStyles;
  final String currentGender;

  const FavoriteFilter({
    super.key,
    required this.selectedIndexFavorites,
    required this.selectedIndex,
    required this.onSpeakerTap,
    required this.onFavoriteToggle,
    required this.currentLanguage,
    required this.currentCategories,
    required this.currentStyles,
    required this.currentGender,
  });

  List<SpeakerEntity> _filterFavorites(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;

    // กรองเฉพาะไอเทมที่ถูกกด Favorite
    List<SpeakerEntity> filtered = SpeakerModel.speakerItem
        .where((item) => selectedIndexFavorites.contains(item.speakerId))
        .toList();

    // กรองตามภาษา
    filtered = filtered.where((item) => item.language == currentLanguage).toList();

    // ถ้าไม่มีไอเทมตรงภาษา ให้เลือกที่ availableLanguage
    if (filtered.isEmpty) {
      filtered = SpeakerModel.speakerItem
          .where((item) =>
              selectedIndexFavorites.contains(item.speakerId) &&
              item.availableLanguage.contains(currentLanguage.toLowerCase()) &&
              item.language != currentLanguage)
          .toList();
    }

    // กรองตามเพศ
    if (currentGender.isNotEmpty) {
      filtered = filtered.where((item) => item.gender == currentGender).toList();
    }

    // กรองตาม voice style
    if (currentStyles.isNotEmpty) {
      filtered = filtered.where((item) {
        if (languageCode == 'th') {
          return item.voiceStyle.isNotEmpty &&
              item.voiceStyle.any((style) => currentStyles.contains(style));
        } else {
          return item.engVoiceStyle.isNotEmpty &&
              item.engVoiceStyle.any((style) => currentStyles.contains(style));
        }
      }).toList();
    }

    // กรองตาม speech style / category
    if (currentCategories.isNotEmpty) {
      filtered = filtered.where((item) {
        if (languageCode == 'th') {
          return item.speechStyle.isNotEmpty &&
              item.speechStyle.any((category) => currentCategories.contains(category));
        } else {
          return item.engSpeechStyle.isNotEmpty &&
              item.engSpeechStyle.any((category) => currentCategories.contains(category));
        }
      }).toList();
    }

    logger.i("Total favorite speakers after filtering: ${filtered.length}");
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSpeakers = _filterFavorites(context);

    if (favoriteSpeakers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Text(
            'ไม่มีผู้พูดที่ถูกใจในภาษานี้',
            style: GoogleFonts.prompt(fontSize: 16.sp, color: Colors.black54),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favoriteSpeakers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final data = favoriteSpeakers[index];
              final originalIndex = SpeakerModel.speakerItem
                  .indexWhere((s) => s.speakerId == data.speakerId);

              return SpeakerGridItem(
                key: ValueKey(data.speakerId),
                speakerItem: data,
                index: originalIndex,
                isSelected: selectedIndex.contains(originalIndex),
                isFavorite: true,
                onSpeakerTap: onSpeakerTap,
                onFavoriteToggle: onFavoriteToggle,
              );
            },
          ),

          // เพิ่มพื้นที่ว่างด้านล่าง
          SizedBox(height: 50.h), 
        ],
      ),
    );
  }
}
