import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
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
  late Soundpool _soundPool;
  SharedPreferences pref;
  late AudioCache _audioCache;
  AudioPlayer? _audioPlayer;
  SoundTrack? _trackPlaying;

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

  SoundUtils(this.pref) {
    _soundPool = Soundpool.fromOptions(
        options: SoundpoolOptions(streamType: StreamType.music, maxStreams: 2));
    if (pref.getBool(SOUND_EFFECTS) ?? SOUND_EFFECTS_DEFAULT) {
      loadSoundEffects();
    }
    Get.put<Soundpool>(_soundPool);

    _audioCache = AudioCache();
    Get.put<AudioCache>(_audioCache);
  }

  loadSoundEffects() async {
    _soundAssetPaths.forEach((k, v) async {
      final soundId = _soundIds[k];
      if (soundId == null || soundId <= 0) {
        var asset = await rootBundle.load(v);
        final soundId = await _soundPool.load(asset);
        _soundIds.addAll({k: soundId});
      }
    });
  }

  Future<int> playSoundEffect(SoundEffect soundEffect) async {
    if (pref.getBool(SOUND_EFFECTS) ?? SOUND_EFFECTS_DEFAULT) {
      final soundId = _soundIds[soundEffect];
      if (soundId != null && soundId > 0) {
        final volume = (pref.getDouble(VOLUME) ?? VOLUME_DEFAULT) / 100.0;
        _soundPool.setVolume(soundId: soundId, volume: volume);
        final streamId = await _soundPool.play(soundId);
        _streamIds.addAll({soundEffect: streamId});
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
    if (streamId != null && streamId > 0) {
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
    _audioPlayer?.setVolume(newVolume / 100.0);
  }

  Future<void> playSoundTrack(SoundTrack track) async {
    if (pref.getBool(GAME_MUSIC) ?? GAME_MUSIC_DEFAULT) {
      if (_trackPlaying == track) {
        return;
      }

      await stopAllSoundTracks();
      final trackPath = _soundTrackPaths[track];
      if (trackPath == null) {
        return;
      }

      _audioPlayer = await _audioCache.loop(trackPath);
      _trackPlaying = track;
      _audioPlayer?.setVolume((pref.getDouble(VOLUME) ?? VOLUME_DEFAULT) / 100.0);
    }
    return null;
  }

  stopAllSoundTracks() async {
    _audioPlayer?.stop();
    _trackPlaying = null;
  }
}
