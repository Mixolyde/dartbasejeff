library board_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('board location tests', () {
    test('neighbor location', () {
      var origin = const BoardLoc(0, 0);
      expect(const BoardLoc(1,0), origin.neighborLoc(CardOrientation.right));
    });
  });
}
