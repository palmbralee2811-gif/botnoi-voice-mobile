import 'package:flutter/material.dart';

String getDefaultSpeakerId(BuildContext context) {
  String languageCode = Localizations.localeOf(context).languageCode;
  languageCode = languageCode.isNotEmpty ? languageCode : 'en';
  switch (languageCode) {
    case 'th':
      // Thai `Ava`
      return '1';
    case 'en':
      // English `Nadia`
      return '9';
    case 'id':
      // Indonesian `Dia`
      return '65';
    default:
      // English `Nadia`
      return '9';
  }
}
