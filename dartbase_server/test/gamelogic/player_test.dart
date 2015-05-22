library player_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('player tests', () {
    test('player creation', () {
      Player p = new Player(1, "Brian");
      expect(p.playerNum, 1);
      expect(p.name, "Brian");
      expect(p.cash, 50);
    });
    test('player equality', () {
      Player p1 = new Player(1, "Brian");
      Player p2 = new Player(1, "Brian");

      expect(p1 == p2, isTrue);

      p2.cash = 5;

      expect(p1 == p2, isFalse);
    });
  });
}
