library game_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card tests', () {
    test('card orientation', () {
      expect(CardDirection.up, CardUtil.opposite(CardDirection.down));
      expect(CardDirection.right, CardUtil.opposite(CardDirection.left));
      expect(CardDirection.right, CardUtil.cw(CardDirection.up));
      expect(CardDirection.right, CardUtil.ccw(CardDirection.down));
      expect(CardDirection.up, CardUtil.cw(CardDirection.left));
      expect(CardDirection.up, CardUtil.ccw(CardDirection.right));
    });
  });
}
