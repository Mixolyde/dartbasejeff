library player_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card tests', () {
    test('card orientation', () {
      expect(CardOrientation.up, CardUtil.opposite(CardOrientation.down));
      expect(CardOrientation.right, CardUtil.opposite(CardOrientation.left));
      expect(CardOrientation.right, CardUtil.cw(CardOrientation.up));
      expect(CardOrientation.right, CardUtil.ccw(CardOrientation.down));
      expect(CardOrientation.up, CardUtil.cw(CardOrientation.left));
      expect(CardOrientation.up, CardUtil.ccw(CardOrientation.right));
    });
  });
}
