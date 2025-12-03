import 'package:botnoivoice/screen/main/home/function/download_file_to_temp.dart';
import 'package:botnoivoice/screen/main/home/widget/audio_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// Request Permission, Call download function, Open audio player, and open audio file
Future openAudioPlayerDialog(
  BuildContext context,
  String audioUrl,
  String? fileName,
) async {
  try {
    // Set Audio File Name from Audio URL
    final name = fileName ?? audioUrl.split("/").last;
    // Save Audio File to Temporary Directory
    final file = await downloadFileToTemporaryDirectory(audioUrl, name);
    if (file == null) return;
    _logger.i("Path: ${file.path}");

    // Open Audio Player Dialog with `file.path` and `audioUrl`
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AudioPlayerDialog(filePath: file.path, audioUrl: audioUrl),
    );
  } catch (e) {
    _logger.e("Failed to open file: $e");
  }
}
