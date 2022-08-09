import 'package:flutter/material.dart';

import '../services/services.dart';

class SeekButton extends StatelessWidget {
  final SeekDirection direction;
  final VoidCallback onTap;

  const SeekButton({
    Key? key,
    required this.direction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        direction == SeekDirection.forward
            ? Icons.skip_next_rounded
            : Icons.skip_previous_rounded,
      ),
    );
  }
}


