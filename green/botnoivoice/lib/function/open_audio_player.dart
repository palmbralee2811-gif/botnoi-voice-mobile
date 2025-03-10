import 'package:botnoivoice/function/download_file_to_temp.dart';
import 'package:botnoivoice/ui/screen/main/audio_player/audio_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// Request Permission, Call download function, Open audio player, and open audio file
Future openAudioPlayerDialog(
  BuildContext context,
  String url,
  String? fileName,
  String audioUrl,
) async {
  try {
    final name = fileName ?? url.split("/").last;
    final file = await downloadFileToTemporaryDirectory(url, name);
    if (file == null) return;
    _logger.i("Path: ${file.path}");

    await showDialog(
      context: context,
      builder: (context) =>
          AudioPlayerDialog(filePath: file.path, audioUrl: audioUrl),
    );
  } catch (e) {
    _logger.e("Failed to open file: $e");
  }
}
