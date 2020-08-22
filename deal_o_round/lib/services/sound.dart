import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:universal_platform/universal_platform.dart';
import 'settings_constants.dart';

enum SoundEffect { ShortCardShuffle, LongCardShuffle, PokerChips }
final Map<SoundEffect, String> _soundAssetPaths = {
  SoundEffect.ShortCardShuffle: "assets/short_card_shuffle.mp3",
  SoundEffect.LongCardShuffle: "assets/long_card_shuffle.mp3",
  SoundEffect.PokerChips: "assets/poker_chips.mp3",
};

enum SoundTrack { SaloonMusic, GuitarMusic, EndMusic }
final Map<SoundTrack, String> _soundTrackPaths = {
  SoundTrack.SaloonMusic: "saloon_music.mp3",
  SoundTrack.GuitarMusic: "guitar_music.mp3",
  SoundTrack.EndMusic: "who_likes_to_party.mp3",
};

class SoundUtils {
  Soundpool _soundPool;
  SharedPreferences pref;
  AudioCache _audioCache;
  AudioPlayer _audioPlayer;
  SoundTrack _trackPlaying;

  Map<SoundEffect, int> _soundIds = {
    SoundEffect.ShortCardShuffle: 0,
    SoundEffect.LongCardShuffle: 0,
    SoundEffect.PokerChips: 0
  };
  Map<SoundEffect, int> _streamIds = {
    SoundEffect.ShortCardShuffle: 0,
    SoundEffect.LongCardShuffle: 0,
    SoundEffect.PokerChips: 0
  };

  SoundUtils({this.pref}) {
    Get.putAsync<Soundpool>(() async {
      _soundPool = Soundpool(
        streamType: StreamType.notification,
        maxStreams: 2
      );
      if (pref.getBool(SOUND_EFFECTS)) {
        await loadSoundEffects();
      }
      return _soundPool;
    });
    Get.putAsync<AudioCache>(() async {
      _audioCache = AudioCache();
      if (UniversalPlatform.isIOS) {
        if (_audioCache.fixedPlayer != null) {
          _audioCache.fixedPlayer.startHeadlessService();
        }
      }
      return _audioCache;
    });
  }

  loadSoundEffects() async {
    _soundAssetPaths.forEach((k, v) async {
      if (_soundIds[k] <= 0) {
        var asset = await rootBundle.load(v);
        final soundId = await _soundPool.load(asset);
        _soundIds.addAll({ k: soundId });
      }
    });
  }

  Future<int> playSoundEffect(SoundEffect soundEffect) async {
    if (pref.getBool(SOUND_EFFECTS)) {
      final soundId = _soundIds[soundEffect];
      if (soundId > 0) {
        final volume = pref.getDouble(VOLUME) / 100.0;
        _soundPool.setVolume(soundId: soundId, volume: volume);
        final streamId = await _soundPool.play(soundId);
        _streamIds.addAll({ soundEffect: streamId});
        _soundPool.setVolume(streamId: streamId, volume: volume);
        return streamId;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  stopSoundEffect(SoundEffect soundEffect) async {
    final streamId = _streamIds[soundEffect];
    if (streamId > 0) {
      await _soundPool.stop(streamId);
      _streamIds[soundEffect] = 0;
    }
  }

  stopAllSoundEffects() async {
    _soundIds.forEach((k, v) async {
      await stopSoundEffect(k);
    });
  }

  Future<void> updateVolume(newVolume) async {
    _soundIds.forEach((k, v) async {
      _soundPool.setVolume(soundId: v, volume: newVolume / 100.0);
    });
    if (_audioPlayer != null) {
      _audioPlayer.setVolume(newVolume / 100.0);
    }
  }

  Future<AudioPlayer> playSoundTrack(SoundTrack track) async {
    if (pref.getBool(GAME_MUSIC)) {
      if (_trackPlaying == track) {
        return _audioPlayer;
      }
      await stopAllSoundTracks();
      _audioPlayer = await _audioCache.loop(_soundTrackPaths[track]);
      _trackPlaying = track;
      if (UniversalPlatform.isWeb) {
        _audioPlayer.startHeadlessService();
      }
      _audioPlayer.setVolume(pref.getDouble(VOLUME) / 100.0);
      return _audioPlayer;
    }
    return null;
  }

  stopAllSoundTracks() async {
    if (_audioPlayer != null) {
      _audioPlayer.stop();
      _trackPlaying = null;
    }
  }
}
