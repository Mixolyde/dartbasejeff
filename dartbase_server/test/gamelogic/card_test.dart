library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  
  group('card tests', () {
    test('card orientation', () {
      expect(CardOrientation.UP, CardOrientationUtil.opposite(CardOrientation.DOWN));
      expect(CardOrientation.RIGHT, CardOrientationUtil.opposite(CardOrientation.LEFT));
      expect(CardOrientation.RIGHT, CardOrientationUtil.cw(CardOrientation.UP));
      expect(CardOrientation.RIGHT, CardOrientationUtil.ccw(CardOrientation.DOWN));
      expect(CardOrientation.UP, CardOrientationUtil.cw(CardOrientation.LEFT));
      expect(CardOrientation.UP, CardOrientationUtil.ccw(CardOrientation.RIGHT));
      
    });
  });
}
