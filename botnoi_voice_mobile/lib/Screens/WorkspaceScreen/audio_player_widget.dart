import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.centerLeft,
      //icon: Icon(_isPlaying ? Icons.stop_circle : Icons.play_circle_fill),
      icon: Icon(audioPlayerState == PlayerState.playing
          ? Icons.stop_circle
          : Icons.play_circle_fill),
      onPressed: togglePlayPause,
    );
  }

  Future<void> togglePlayPause() async {
    if (audioPlayerState == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  playMusic() async {
    await audioPlayer.play(widget.audioUrl as Source);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }
}
