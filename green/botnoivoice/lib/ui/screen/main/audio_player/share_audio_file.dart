import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareAudioFile(BuildContext context, String mp3FilePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final shareResult = await Share.shareXFiles(
    [XFile(mp3FilePath)],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );

  scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
}

SnackBar getResultSnackBar(ShareResult result) {
  String message;
  switch (result.status) {
    case ShareResultStatus.success:
      message = 'Share Audio File Successful';
      break;
    case ShareResultStatus.dismissed:
      message = 'Share Audio File Dismissed';
      break;
    default:
      message = 'Share Audio File Failed';
      break;
  }
  return SnackBar(content: Text(message));
}
