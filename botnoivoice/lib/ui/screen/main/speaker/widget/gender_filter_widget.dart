import 'package:botnoivoice/ui/screen/main/speaker/widget/filter_option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenderFilterWidget extends StatelessWidget {
  final String thaiName;
  final String englishName;
  final String indonesianName;
  final String imagePath;
  final String gender;
  final void Function(String displayText, String imagePath, String gender) onSelected;

  const GenderFilterWidget({
    super.key,
    required this.thaiName,
    required this.englishName,
    required this.indonesianName,
    required this.imagePath,
    required this.gender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    languageCode = languageCode.isNotEmpty ? languageCode : 'en';

    Map<String, String> languageMap = {
      'th': thaiName,
      'en': englishName,
      'id': indonesianName,
    };

    String displayText = languageMap[languageCode]?.isNotEmpty == true
        ? languageMap[languageCode]!
        : englishName;

    return InkWell(
      onTap: () {
        onSelected(displayText, imagePath, gender);
        context.pop();
      },
      child: FilterOption(
        imagePath: imagePath,
        text: displayText,
        isSelected: false, // ไม่ต้องเช็กในนี้ เพราะใช้ตอนสร้าง Widget
      ),
    );
  }
}
