library board_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('board location tests', () {
    test('neighbor location', () {
      expect(BoardLoc.origin.neighborLoc(CardOrientation.right), const BoardLoc(1,0));
      expect(BoardLoc.origin.neighborLoc(CardOrientation.left), const BoardLoc(-1,0));
    });
  });
  
  group('playerd card tests', () {
    test('COM played card exits', () {
      var pc = const PlayedCard(Card.COM, CardOrientation.down, 1);
      expect(pc.exits().length, 1);
      expect(pc.exits(), contains(CardOrientation.down));
    });
    
    test('POW played card exits', () {
      var pc = const PlayedCard(Card.POW, CardOrientation.down, 1);
      expect(pc.exits().length, 4);
      expect(pc.exits(), contains(CardOrientation.down));
      expect(pc.exits(), contains(CardOrientation.up));
      expect(pc.exits(), contains(CardOrientation.left));
      expect(pc.exits(), contains(CardOrientation.right));
    });
  });
}
