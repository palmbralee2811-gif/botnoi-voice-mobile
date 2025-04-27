import 'package:botnoivoice/screen/main/speaker/widget/filter_option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildLanguageFilterWidget({
  required String thaiName,
  required String englishName,
  required String indonesianName,
  required String imagePath,
  required String lang,
  required BuildContext context,
  required StateSetter setState,
  required Function(String, String, String) onSelected,
  required String selectedLanguage,
}) {
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
      setState(() {
        onSelected(lang, displayText, imagePath);
      });

      // ปิด Modal ทันทีหลังจากเลือกภาษา
      context.pop();
    },
    child: FilterOption(
      imagePath: imagePath,
      text: displayText,
      isSelected: selectedLanguage == displayText,
    ),
  );
}
