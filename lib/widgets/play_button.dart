import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPlayed;

  const PlayButton({
    Key? key,
    required this.onTap,
    required this.isPlayed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      onPressed: onTap,
      icon: Icon(
        isPlayed ? Icons.pause : Icons.play_arrow_rounded,
      ),
    );
  }
}
