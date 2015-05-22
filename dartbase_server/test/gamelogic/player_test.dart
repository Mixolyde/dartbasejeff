library player_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('player tests', () {
    test('player creation', () {
      Player p = new Player(1, "Brian");
      expect(p.playerNum, 1);
      expect(p.name, "Brian");
      expect(p.cash, 0);
    });
  });
}
