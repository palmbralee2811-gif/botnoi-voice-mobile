import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteFilter extends StatelessWidget {
  final List<String> selectedIndexFavorites;
  final Set<int> selectedIndex;
  final Function(int index, SpeakerEntity speaker) onSpeakerTap;
  final Function(String speakerId) onFavoriteToggle;
  final String currentLanguage;

  const FavoriteFilter(
      {super.key,
      required this.selectedIndexFavorites,
      required this.selectedIndex,
      required this.onSpeakerTap,
      required this.onFavoriteToggle,
      required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    final List<SpeakerEntity> favoriteSpeakers = SpeakerModel.speakerItem
        .where((item) =>
            selectedIndexFavorites.contains(item.speakerId) &&
            item.language == currentLanguage)
        .toList();

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

    return SizedBox(
      height: 420.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: favoriteSpeakers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          childAspectRatio: 0.8,
        ),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final data = favoriteSpeakers[index];
          final originalIndex = SpeakerModel.speakerItem
              .indexWhere((s) => s.speakerId == data.speakerId);

          return SpeakerGridItem(
            speakerItem: data,
            index: originalIndex,
            isSelected: selectedIndex.contains(originalIndex),
            isFavorite: true,
            onSpeakerTap: onSpeakerTap,
            onFavoriteToggle: onFavoriteToggle,
          );
        },
      ),
    );
  }
}