import 'package:deal_o_round/game/logic/game_constants.dart';
import 'package:deal_o_round/game/logic/level_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Neighbor highlight tests', () {
    test('Easy difficulty has diagonal selection on all levels', () async {
      final levelManager = LevelManager();
      for (final _ in Iterable<int>.generate(30)) {
        expect(levelManager.hasDiagonalSelection(Difficulty.easy), true);
        levelManager.advanceLevel();
      }
    });

    test('Medium has diagonal selection on first two levels', () async {
      final levelManager = LevelManager();
      for (final level in Iterable<int>.generate(30)) {
        expect(levelManager.hasDiagonalSelection(Difficulty.medium), level < 2);
        levelManager.advanceLevel();
      }
    });

    test('Hard does not have diagonal selection', () async {
      final levelManager = LevelManager();
      for (final _ in Iterable<int>.generate(30)) {
        expect(levelManager.hasDiagonalSelection(Difficulty.hard), false);
        levelManager.advanceLevel();
      }
    });
  });
}
