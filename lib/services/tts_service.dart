import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../utils/constants/user_data.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;

  TTSService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future init() async {
    if (_isInitialized) return;

    await _tts.setLanguage("en-IN"); // 🔥 better for Indian accent
    await _tts.setSpeechRate(0.38); // 🔥 slower = more understandable
    await _tts.setPitch(1.0); // natural pitch
    await _tts.setVolume(1.0);

    _isInitialized = true;
  }

  Future speak(String text) async {
    final userInfo = Get.find<UserInfo>();

    if (!userInfo.isTtsEnabled.value) return;
    if (text.trim().isEmpty) return;

    Completer completer = Completer();

    _tts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _tts.setErrorHandler((msg) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await _tts.stop();
    await _tts.speak(text);

    // ✅ WAIT until speech actually finishes
    await completer.future;
  }

  Future stop() async {
    await _tts.stop();
  }
}
