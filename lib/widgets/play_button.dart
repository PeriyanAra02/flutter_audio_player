import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onTap;

  const PlayButton({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool isPlayed = false;
  late AudioPlayer player;

  @override
  void initState() {
    player = AudioPlayer(
      audioLoadConfiguration: AudioLoadConfiguration(
        darwinLoadControl: DarwinLoadControl(
          preferredForwardBufferDuration: const Duration(minutes: 1),
          preferredPeakBitRate: 50000,
        ),
        androidLoadControl: AndroidLoadControl(
          maxBufferDuration: const Duration(minutes: 2),
          minBufferDuration: const Duration(minutes: 2),
          bufferForPlaybackDuration: const Duration(minutes: 1),
          targetBufferBytes: 50000,
        ),
      ),
    );

    player.playerStateStream.listen((event) {
      inspect(player);
      log(
        '${player.bufferedPosition}',
        name: '_player.bufferedPosition',
      );
    });

    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      onPressed: () {
        widget.onTap();
        if (isPlayed) {
          _pause();
        } else {
          _play();
        }

        setState(() {
          isPlayed = !isPlayed;
        });
      },
      icon: Icon(
        isPlayed ? Icons.pause : Icons.play_arrow_rounded,
      ),
    );
  }

  Future<void> _init() async {
    final audioSource = LockCachingAudioSource(
        Uri.parse('http://887797-katamoto.tmweb.ru/001.mp3'));
    await player.setAudioSource(audioSource);
  }

  Future<void> _play() async {
    await player.play();
  }

  Future<void> _pause() async {
    await player.pause();
  }
}
