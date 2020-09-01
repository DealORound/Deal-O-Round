import 'package:deal_o_round/game/logic/game_constants.dart';
import 'package:deal_o_round/game/logic/level_manager.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Neighbor highlight tests', () {
    test('Easy difficulty has neighbor highlight on all levels', () async {
      final levelManager = LevelManager();
      for (final _ in Iterable<int>.generate(30).toList()) {
        expect(levelManager.hasNeighborSelection(Difficulty.Easy), true);
        levelManager.advanceLevel();
      }
    });

    test('Medium has neighbor highlight on first five levels', () async {
      final levelManager = LevelManager();
      for (final level in Iterable<int>.generate(30).toList()) {
        expect(levelManager.hasNeighborSelection(Difficulty.Medium), level < 5);
        levelManager.advanceLevel();
      }
    });

    test('Hard has neighbor highlight only on the first levels', () async {
      final levelManager = LevelManager();
      for (final level in Iterable<int>.generate(30).toList()) {
        expect(levelManager.hasNeighborSelection(Difficulty.Hard), level < 1);
        levelManager.advanceLevel();
      }
    });

  });
}
