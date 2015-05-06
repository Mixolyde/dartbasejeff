library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  
  group('card tests', () {
    test('card orientation', () {
      expect(CardOrientation.UP, CardOrientationUtil.opposite(CardOrientation.DOWN));
      
    });
  });
}