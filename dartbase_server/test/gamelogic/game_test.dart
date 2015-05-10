library game_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card tests', () {
    test('card orientation', () {
      expect(CardOrientation.UP, CardUtil.opposite(CardOrientation.DOWN));
      expect(CardOrientation.RIGHT, CardUtil.opposite(CardOrientation.LEFT));
      expect(CardOrientation.RIGHT, CardUtil.cw(CardOrientation.UP));
      expect(CardOrientation.RIGHT, CardUtil.ccw(CardOrientation.DOWN));
      expect(CardOrientation.UP, CardUtil.cw(CardOrientation.LEFT));
      expect(CardOrientation.UP, CardUtil.ccw(CardOrientation.RIGHT));
    });
  });
}
