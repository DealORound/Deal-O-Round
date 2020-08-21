import 'package:deal_o_round/services/settings_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

enum SoundEffect { ShortCardShuffle, LongCardShuffle, PokerChips }
final Map<SoundEffect, String> _soundAssetPaths = {
  SoundEffect.ShortCardShuffle: "assets/short_card_shuffle.mp3",
  SoundEffect.LongCardShuffle: "assets/long_card_shuffle.mp3",
  SoundEffect.PokerChips: "assets/poker_chips.mp3",
};

class SoundUtils {
  Soundpool _soundPool;
  SharedPreferences pref;
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
        final streamId = await _soundPool.play(soundId);
        _streamIds.addAll({ soundEffect: streamId});
        return streamId;
      }
    }
    return 0;
  }

  // Not web compatible right now
  pauseSoundEffect(SoundEffect soundEffect) async {
    final streamId = _streamIds[soundEffect];
    if (streamId > 0) {
      await _soundPool.pause(streamId);
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

  Future<void> updateVolume(newVolume) async{
    _soundIds.forEach((k, v) async {
      _soundPool.setVolume(soundId: v, volume: newVolume);
    });
  }
}
