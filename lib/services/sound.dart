import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
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
  late AudioPlayer _audioPlayer;
  SharedPreferences pref;
  AssetsAudioPlayer? _assetsPlayer;
  SoundTrack? _trackPlaying;

  final Map<SoundEffect, AssetSource> _soundCache = {};

  SoundUtils(this.pref) {
    _audioPlayer = AudioPlayer();
    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      loadSoundEffects();
    }
    Get.put<AudioPlayer>(_audioPlayer);

    _assetsPlayer = AssetsAudioPlayer.newPlayer();
    _assetsPlayer?.setLoopMode(LoopMode.single);
  }

  Future<void> loadSoundEffects() async {
    _soundAssetPaths.forEach((k, v) async {
      if (!_soundCache.containsKey(k)) {
        final soundSource = AssetSource(v);
        _soundCache.addAll({k: soundSource});
      }
    });
  }

  Future<int> playSoundEffect(SoundEffect soundEffect) async {
    if (!_soundCache.containsKey(soundEffect)) {
      return 0;
    }

    if (pref.getBool(soundEffectsTag) ?? soundEffectsDefault) {
      final volumePercent = (pref.getDouble(volumeTag) ?? volumeDefault);
      final volume = volumePercent / 100.0;
      await _audioPlayer.play(_soundCache[soundEffect]!, volume: volume);
      return 1;
    } else {
      return 0;
    }
  }

  Future<void> stopSoundEffects() async {
    await _audioPlayer.stop();
  }

  Future<void> updateVolume(newVolume) async {
    await _assetsPlayer?.setVolume(newVolume / 100.0);
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
      await _assetsPlayer?.setVolume(
        (pref.getDouble(volumeTag) ?? volumeDefault) / 100.0,
      );
      await _assetsPlayer?.open(Audio("assets/$trackPath"));
    }
    return;
  }

  stopAllSoundTracks() async {
    await _assetsPlayer?.stop();
    _trackPlaying = null;
  }
}
