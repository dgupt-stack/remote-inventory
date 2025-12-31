import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _lastWords = '';

  Future<void> initialize() async {
    await _speech.initialize();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<String?> startListening() async {
    if (!_speech.isAvailable) {
      await initialize();
    }

    if (_speech.isAvailable && !_isListening) {
      _isListening = true;
      _lastWords = '';

      await _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
        },
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 3),
      );

      // Wait for listening to complete
      await Future.delayed(const Duration(seconds: 6));
      _isListening = false;

      return _lastWords.isNotEmpty ? _lastWords : null;
    }

    return null;
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void dispose() {
    _speech.cancel();
    _tts.stop();
  }
}
