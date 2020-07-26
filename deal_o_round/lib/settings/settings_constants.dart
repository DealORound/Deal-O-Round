enum Difficulty { Easy, Medium, Hard }
enum BoardLayout { Square, Hexagonal }

const DIFFICULTY = 'difficulty';
const BOARD_LAYOUT = 'layout';
const GAME_MUSIC = 'music';
const SOUND_EFFECTS = 'snd_fx';
const VOLUME = 'volume';
const SCREEN_SCALE = 'screen_scale';
const ANIMATION_SPEED = 'anim_speed';
const REFRESH_RATE = 'refresh_rate';

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split(".").last == value,
      orElse: () => null);
}
