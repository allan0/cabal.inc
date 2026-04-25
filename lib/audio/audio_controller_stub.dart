// lib/audio/audio_controller_stub.dart
// This is the fake implementation for the web. It does nothing.

class AudioController {
  // A private constructor to prevent instantiation from outside.
  AudioController._internal();

  // A singleton instance.
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  
  // All methods are empty because audio is disabled on the web.
  Future<void> initialize() async {}
  void dispose() {}
  Future<void> playSfx() async {}
  Future<void> startMusic() async {}
  void stopMusic() {}
}
