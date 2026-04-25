// lib/audio/audio_controller_mobile.dart
// This is the real implementation for mobile/desktop.
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  final SoLoud _soloud = SoLoud.instance;
  final List<AudioSource> _sfx = [];
  AudioSource? _music;
  SoundHandle? _musicHandle;

  final _random = Random();

  Future<void> initialize() async {
    // We no longer need the kIsWeb check here because this file is never
    // imported on the web.
    await _soloud.init();

    final sfxAssets = [
      'assets/audio/audio_soloud_step_06_assets_sounds_pew1.mp3',
      'assets/audio/audio_soloud_step_06_assets_sounds_pew2.mp3',
      'assets/audio/audio_soloud_step_06_assets_sounds_pew3.mp3',
    ];
    for (final asset in sfxAssets) {
      try {
        final sfxSource = await _soloud.loadAsset(asset);
        _sfx.add(sfxSource);
      } catch (e) {
        _log.warning('Could not load sound effect: $asset. Error: $e');
      }
    }

    _log.info('AudioController initialized');
  }

  void dispose() {
    _soloud.deinit();
    _log.info('AudioController disposed');
  }

  Future<void> playSfx() async {
    if (_sfx.isEmpty) {
      return;
    }
    final sound = _sfx[_random.nextInt(_sfx.length)];
    await _soloud.play(sound);
  }

  Future<void> startMusic() async {
    if (_musicHandle != null) return;
    try {
      if (_music == null) {
        _music = await _soloud.loadAsset(
          'assets/audio/audio_soloud_step_06_assets_music_looped-song.ogg',
          mode: LoadMode.memory,
        );
      }
      _musicHandle = await _soloud.play(_music!, looping: true, volume: 0.3);
      _log.info('Music started');
    } catch (e) {
      _log.severe('Could not start music', e);
      _music = null;
      _musicHandle = null;
    }
  }

  void stopMusic() {
    if (_musicHandle == null) return;
    _soloud.stop(_musicHandle!);
    _musicHandle = null;
    _log.info('Music stopped');
  }
}
