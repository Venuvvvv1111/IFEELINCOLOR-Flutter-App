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

    await _tts.setLanguage("en-US"); // US voice
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);

    // Optional: better handling
    await _tts.awaitSpeakCompletion(true);

    _isInitialized = true;
  }

  Future speak(String text) async {
    try {
      final userInfo = Get.find<UserInfo>();

      //  Respect user setting
      if (!userInfo.isTtsEnabled.value) return;

      if (text.trim().isEmpty) return;

      await _tts.stop(); // stop previous speech
      await _tts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  Future stop() async {
    await _tts.stop();
  }
}