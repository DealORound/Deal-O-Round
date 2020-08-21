enum Difficulty { Easy, Medium, Hard }
enum BoardLayout { Square, Hexagonal }

const DIFFICULTY = 'difficulty';
const DIFFICULTY_DEFAULT = "Easy";
const DIFFICULTY_DEFAULT_VALUE = Difficulty.Easy;
const BOARD_LAYOUT = 'layout';
const BOARD_LAYOUT_DEFAULT = "Hexagonal";
const BOARD_LAYOUT_DEFAULT_VALUE = BoardLayout.Hexagonal;
const GAME_MUSIC = 'music';
const GAME_MUSIC_DEFAULT = false;
const SOUND_EFFECTS = 'snd_fx';
const SOUND_EFFECTS_DEFAULT = true;
const VOLUME = 'volume';
const VOLUME_DEFAULT = 15.0;
const SCREEN_SCALE = 'screen_scale';
const SCREEN_SCALE_DEFAULT = 1.0;
const ANIMATION_SPEED = 'anim_speed';
const ANIMATION_SPEED_DEFAULT = 200.0;
const REFRESH_RATE = 'refresh_rate';
const REFRESH_RATE_DEFAULT = 60.0;

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split(".").last == value,
      orElse: () => null);
}