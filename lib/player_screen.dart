import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:player/services/services.dart';
import 'package:player/widgets/play_button.dart';
import 'package:player/widgets/seek_bar.dart';
import 'package:player/widgets/seek_button.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late MyAudioHandler audioHandler;
  bool isPlayed = false;

  @override
  void initState() {
    audioHandler = MyAudioHandler();

    audioHandler.player.positionStream.listen((event) {
      if (event.inSeconds == audioHandler.player.duration?.inSeconds) {
        setState(() {
          isPlayed = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(
                'assets/images/player_cover.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Sweater Weather',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            StreamBuilder<Duration>(
              stream: audioHandler.player.positionStream,
              builder: (context, snapshot) {
                final data = snapshot.data;

                if (data != null) {
                  return SeekBar(
                    duration: audioHandler.player.duration ?? Duration.zero,
                    position: data,
                    onChanged: (position) => audioHandler.seek(
                      position,
                    ),
                  );
                }

                return const SeekBar(
                  duration: Duration.zero,
                  position: Duration.zero,
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SeekButton(
                  direction: SeekDirection.backward,
                  onTap: () {
                    _onSeek(SeekDirection.backward);
                  },
                ),
                PlayButton(
                  isPlayed: isPlayed,
                  onTap: () {
                    if (isPlayed) {
                      audioHandler.pause();
                    } else {
                      audioHandler.play();
                    }
                    setState(() {
                      isPlayed = !isPlayed;
                    });
                  },
                ),
                SeekButton(
                  direction: SeekDirection.forward,
                  onTap: () {
                    _onSeek(SeekDirection.forward);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onSeek(SeekDirection direction) {
    if (direction == SeekDirection.forward) {
      audioHandler.seekForward(false);
    } else {
      audioHandler.seekBackward(false);
    }
  }
}
