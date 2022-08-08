import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:player/services/services.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  late AudioHandler audioHandler;
  bool isPlayed = false;

  @override
  void initState() {
    audioHandler = MyAudioHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      onPressed: () {
        if (isPlayed) {
          audioHandler.pause();
        } else {
          audioHandler.play();
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
}
