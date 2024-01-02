import 'package:collection/collection.dart';

import '../game/logic/game_constants.dart';

const difficultyTag = 'difficulty';
const difficultyDefault = "Easy";
const difficultyDefaultValue = Difficulty.easy;
const boardLayoutTag = 'layout';
const boardLayoutDefault = "Hexagonal";
const boardLayoutDefaultValue = BoardLayout.hexagonal;
const gameMusicTag = 'music';
const gameMusicDefault = false;
const soundEffectsTag = 'snd_fx';
const soundEffectsDefault = true;
const volumeTag = 'volume';
const volumeDefault = 15.0;
const screenScaleTag = 'screen_scale';
const screenScaleDefault = 1.0;
const animationSpeedTag = 'anim_speed';
const animationSpeedDefault = 200.0;
const gameSignedInTag = 'game_signed_in';

T? enumFromString<T>(Iterable<T> values, String value) {
  return values
      .firstWhereOrNull((type) => type.toString().split(".").last == value);
}
