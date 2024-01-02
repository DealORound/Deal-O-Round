import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'settings_constants.dart';

enum SoundEffect { shortCardShuffle, longCardShuffle, pokerChips }

final Map<SoundEffect, String> _soundAssetPaths = {
  SoundEffect.shortCardShuffle: "assets/short_card_shuffle.mp3",
  SoundEffect.longCardShuffle: "assets/long_card_shuffle.mp3",
  SoundEffect.pokerChips: "assets/poker_chips.mp3",
};

enum SoundTrack { saloonMusic, guitarMusic, endMusic }

final Map<SoundTrack, String> _soundTrackPaths = {
  SoundTrack.saloonMusic: "saloon_music.mp3",
  SoundTrack.guitarMusic: "guitar_music.mp3",
  SoundTrack.endMusic: "who_likes_to_party.mp3",
};

class SoundUtils {
  late Soundpool _soundPool;
  SharedPreferences pref;
  AssetsAudioPlayer? _audioPlayer;
  SoundTrack? _trackPlaying;

  final Map<SoundEffect, int> _soundIds = {
    SoundEffect.shortCardShuffle: 0,
    SoundEffect.longCardShuffle: 0,
    SoundEffect.pokerChips: 0
  };
  final Map<SoundEffect, int> _streamIds = {
    SoundEffect.shortCardShuffle: 0,
    SoundEffect.longCardShuffle: 0,
    SoundEffect.pokerChips: 0
  };

  SoundUtils(this.pref) {
    _soundPool = Soundpool.fromOptions(
        options: const SoundpoolOptions(
            streamType: StreamType.music, maxStreams: 2));
    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      loadSoundEffects();
    }
    Get.put<Soundpool>(_soundPool);

    _audioPlayer = AssetsAudioPlayer.newPlayer();
    _audioPlayer?.setLoopMode(LoopMode.single);
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
    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      final soundId = _soundIds[soundEffect];
      if (soundId != null && soundId > 0) {
        final volume = (pref.getDouble(volumeTag) ?? volumeDefault) / 100.0;
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
    await _audioPlayer?.setVolume(newVolume / 100.0);
  }

  Future<void> playSoundTrack(SoundTrack track) async {
    if (pref.getBool(gameMusicTag) ?? gameMusicDefault) {
      if (_trackPlaying == track) {
        return;
      }

      await stopAllSoundTracks();
      final trackPath = _soundTrackPaths[track];
      if (trackPath == null) {
        return;
      }

      _trackPlaying = track;
      await _audioPlayer
          ?.setVolume((pref.getDouble(volumeTag) ?? volumeDefault) / 100.0);
      await _audioPlayer?.open(Audio("assets/$trackPath"));
    }
    return;
  }

  stopAllSoundTracks() async {
    await _audioPlayer?.stop();
    _trackPlaying = null;
  }
}
