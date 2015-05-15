library board_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('board instance tests', () {
    test('new board is open', () {
      Board board = new Board();
      expect(board.isClosed(), isFalse);
    });
    test('new board has no played cards', () {
      Board board = new Board();
      expect(board.boardMap.keys.length, 0);
    });
  });

  group('board utility tests', () {
    test('legal sabotage locs', () {
      Board board = new Board();
      expect(board.isLegalSabotage(BoardLoc.origin), false);
    });
  });

  group('board location tests', () {
    test('neighbor location', () {
      expect(BoardLoc.origin.neighborLoc(CardDirection.right), const BoardLoc(1,0));
      expect(BoardLoc.origin.neighborLoc(CardDirection.left), const BoardLoc(-1,0));
    });
  });

  group('playerd card tests', () {
    test('COM played card exits', () {
      var pc = const PlayedCard(Card.COM, CardDirection.down, 1);
      expect(pc.exits().length, 1);
      expect(pc.exits(), contains(CardDirection.down));
    });

    test('POW played card exits', () {
      var pc = const PlayedCard(Card.POW, CardDirection.down, 1);
      expect(pc.exits().length, 4);
      expect(pc.exits(), contains(CardDirection.down));
      expect(pc.exits(), contains(CardDirection.up));
      expect(pc.exits(), contains(CardDirection.left));
      expect(pc.exits(), contains(CardDirection.right));
    });
  });
}
