import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  AudioPlayer player = AudioPlayer();

  MyAudioHandler() {
    _init();
  }

  @override
  Future<void> play() async {
    await player.play();
  }

  @override
  Future<void> pause() async {
    await player.pause();
  }

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> seekBackward(bool begin) async {
    if (player.position.inSeconds >= 15) {
      seek(Duration(seconds: player.position.inSeconds - 15));
    }
  }

  @override
  Future<void> seekForward(bool begin) async {
    if (player.duration != null &&
        player.position.inSeconds <= player.duration!.inSeconds) {
      seek(Duration(seconds: player.position.inSeconds + 15));
    }
  }

  Future<void> _init() async {
    log('init');
    player.playerStateStream.listen((event) {
      inspect(player);
    });

    player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekBackward,
          MediaAction.seekForward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });

    final audioSource = LockCachingAudioSource(
      Uri.parse('http://887797-katamoto.tmweb.ru/001.mp3'),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: "Album name",
        title: "Song name",
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1614850715649-1d0106293bd1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Y292ZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
        extras: {},
        rating: const Rating.newHeartRating(true),
      ),
    );
    await player.setAudioSource(audioSource);
  }
}

enum SeekDirection {
  forward,
  backward,
}
