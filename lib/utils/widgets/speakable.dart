import 'package:flutter/material.dart';
import 'package:ifeelin_color/services/tts_service.dart';


class Speakable extends StatelessWidget {
  final String text;
  final Widget child;

  const Speakable({
    super.key,
    required this.text,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        TTSService().speak(text);
      },
      child: child,
    );
  }
}