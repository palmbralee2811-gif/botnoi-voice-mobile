import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'speaker_grid_item.dart';

class BuildMultipleSpeaker extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final Set<int> selectedIndex;
  final List<String> selectedIndexFavorites;
  final String? language;
  final String? gender;
  final Set<String> selectedCategories;
  final Set<String> selectedStyles;
  final Logger logger;
  final Function(int, SpeakerEntity) onSpeakerTap;
  final Function(String) onFavoriteToggle;

  const BuildMultipleSpeaker({
    super.key,
    required this.audioPlayer,
    required this.selectedIndex,
    required this.selectedIndexFavorites,
    required this.language,
    required this.gender,
    required this.selectedCategories,
    required this.selectedStyles,
    required this.logger,
    required this.onSpeakerTap,
    required this.onFavoriteToggle,
  });

  List<SpeakerEntity> _filterSpeakers(BuildContext context) {
    List<SpeakerEntity> filteredSpeakers = [];
    String languageCode = Localizations.localeOf(context).languageCode;

    filteredSpeakers = SpeakerModel.speakerItem.where((item) {
      return item.language == language;
    }).toList();

    if (filteredSpeakers.isEmpty) {
      filteredSpeakers = SpeakerModel.speakerItem.where((item) {
        return item.availableLanguage.contains(language?.toLowerCase()) &&
            item.language != language;
      }).toList();
    }

    if (gender != null && gender!.isNotEmpty) {
      filteredSpeakers =
          filteredSpeakers.where((item) => item.gender == gender).toList();
    }

    if (selectedStyles.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        if (languageCode == 'th') {
          return item.voiceStyle.isNotEmpty &&
              item.voiceStyle.any((style) => selectedStyles.contains(style));
        } else {
          return item.engVoiceStyle.isNotEmpty &&
              item.engVoiceStyle.any((style) => selectedStyles.contains(style));
        }
      }).toList();
    }

    if (selectedCategories.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        if (languageCode == 'th') {
          return item.speechStyle.isNotEmpty &&
              item.speechStyle
                  .any((category) => selectedCategories.contains(category));
        } else {
          return item.engSpeechStyle.isNotEmpty &&
              item.engSpeechStyle
                  .any((category) => selectedCategories.contains(category));
        }
      }).toList();
    }

    if (filteredSpeakers.isEmpty) {
      logger.w("No speakers match all filters.");
      return [];
    }

    logger.i("Total speakers after filtering: ${filteredSpeakers.length}");
    return filteredSpeakers;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filterSpeakers(context);

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีผู้พูดที่ตรงกับเงื่อนไข',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 420.h,
        width: 320.w,
        child: GridView.builder(
          itemCount: filteredItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final data = filteredItems[index];

            return SpeakerGridItem(
              key: ValueKey(data.speakerId),
              speakerItem: data,
              index: index,
              isSelected: selectedIndex.contains(index),
              isFavorite: selectedIndexFavorites.contains(data.speakerId),
              onSpeakerTap: (index, speakerItem) =>
                  onSpeakerTap(index, speakerItem),
              onFavoriteToggle: (speakerId) => onFavoriteToggle(speakerId),
            );
          },
        ),
      ),
    );
  }
}
