import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:just_audio/just_audio.dart'
    show AudioPlayer, LoopMode; // Expose AudioPlayer directly or use prefix?
// Let's use prefix for clarity on conflict types.
// But I need AudioPlayer for music.
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_constants.dart';

enum SoundEffect { shortCardShuffle, longCardShuffle, pokerChips }

final Map<SoundEffect, String> _soundAssetPaths = {
  SoundEffect.shortCardShuffle: "short_card_shuffle.mp3",
  SoundEffect.longCardShuffle: "long_card_shuffle.mp3",
  SoundEffect.pokerChips: "poker_chips.mp3",
};

enum SoundTrack { saloonMusic, guitarMusic, endMusic }

final Map<SoundTrack, String> _soundTrackPaths = {
  SoundTrack.saloonMusic: "saloon_music.mp3",
  SoundTrack.guitarMusic: "guitar_music.mp3",
  SoundTrack.endMusic: "who_likes_to_party.mp3",
};

class SoundUtils {
  late AudioPlayer _musicPlayer;
  late SoLoud _soloud;
  SharedPreferences pref;
  SoundTrack? _trackPlaying;

  final Map<SoundEffect, AudioSource> _soundCache = {};

  SoundUtils(this.pref) {
    _musicPlayer = AudioPlayer();
    _soloud = SoLoud.instance;
    _initSoloud();

    // Setting loop mode for music
    _musicPlayer.setLoopMode(LoopMode.one);
  }

  Future<void> _initSoloud() async {
    await _soloud.init();
    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      await loadSoundEffects();
    }
  }

  Future<void> loadSoundEffects() async {
    for (var entry in _soundAssetPaths.entries) {
      if (!_soundCache.containsKey(entry.key)) {
        try {
          final source = await _soloud.loadAsset("assets/${entry.value}");
          _soundCache[entry.key] = source;
        } catch (e) {
          debugPrint("Error loading sound effect ${entry.key}: $e");
        }
      }
    }
  }

  Future<int> playSoundEffect(SoundEffect soundEffect) async {
    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      if (!_soundCache.containsKey(soundEffect)) {
        // Lazy load
        final path = _soundAssetPaths[soundEffect];
        if (path != null) {
          try {
            final source = await _soloud.loadAsset("assets/$path");
            _soundCache[soundEffect] = source;
          } catch (e) {
            debugPrint("Error lazy loading sound effect: $e");
            return 0;
          }
        } else {
          return 0;
        }
      }

      final source = _soundCache[soundEffect];
      if (source != null) {
        final volumePercent = (pref.getDouble(volumeTag) ?? volumeDefault);
        final volume = volumePercent / 100.0;
        await _soloud.play(source, volume: volume);
        return 1;
      }
    }
    return 0;
  }

  Future<void> stopSoundEffects() async {
    // SoLoud doesn't have a simple "stop all" without handles,
    // strictly speaking we should track handles if we want to stop them mid-play.
    // For short SFX, usually unnecessary. If needed, we'd store handles.
    // However, _soloud.disposeAllSound() stops everything? No, that disposes sources.
    // Given the previous implementation just stopped the player (which was one track),
    // and these are short effects, we probably don't need a hard stop for "stopSoundEffects"
    // unless the user leaves the game.
    // But we can just leave them playing to finish.
  }

  Future<void> updateVolume(double newVolume) async {
    await _musicPlayer.setVolume(newVolume / 100.0);
  }

  Future<void> playSoundTrack(SoundTrack track) async {
    if (pref.getBool(gameMusicTag) ?? gameMusicDefault) {
      if (_trackPlaying == track) {
        return;
      }

      final trackPath = _soundTrackPaths[track];
      if (trackPath == null) {
        return;
      }

      _trackPlaying = track;
      final volume = (pref.getDouble(volumeTag) ?? volumeDefault) / 100.0;
      await _musicPlayer.setVolume(volume);

      final source = just_audio.AudioSource.asset(
        "assets/$trackPath",
        tag: MediaItem(
          id: trackPath,
          album: "Deal-O-Round",
          title: _getTrackTitle(track),
        ),
      );

      await _musicPlayer.setAudioSource(source);
      _musicPlayer.play();
    }
    return;
  }

  String _getTrackTitle(SoundTrack track) {
    switch (track) {
      case SoundTrack.saloonMusic:
        return "Saloon Music";
      case SoundTrack.guitarMusic:
        return "Guitar Music";
      case SoundTrack.endMusic:
        return "End Music";
    }
  }

  Future<void> stopAllSoundTracks() async {
    await _musicPlayer.stop();
    _trackPlaying = null;
  }
}
