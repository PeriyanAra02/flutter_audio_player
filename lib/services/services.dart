import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<MyAudioHandler> initAudioService() async {
  log('init AudioService');
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.player.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidShowNotificationBadge: true,
      androidResumeOnClick: true,
      fastForwardInterval: Duration(seconds: 15),
      rewindInterval: Duration(seconds: 15),
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  AudioPlayer player = AudioPlayer(
    // audioLoadConfiguration: AudioLoadConfiguration(
    //   darwinLoadControl: DarwinLoadControl(
    //     preferredForwardBufferDuration: const Duration(minutes: 1),
    //     preferredPeakBitRate: 50000,
    //   ),
    //   androidLoadControl: AndroidLoadControl(
    //     maxBufferDuration: const Duration(minutes: 2),
    //     minBufferDuration: const Duration(minutes: 2),
    //     bufferForPlaybackDuration: const Duration(minutes: 1),
    //     targetBufferBytes: 50000,
    //   ),
    // ),
  );

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
    player.seek(Duration(seconds: player.position.inSeconds - 15));
  }

  @override
  Future<void> seekForward(bool begin) async {
    player.seek(Duration(seconds: player.position.inSeconds + 15));
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

        // systemActions: const {
        //   MediaAction.seek,
        // },
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
      ),
    );
    await player.setAudioSource(audioSource);
  }
}
