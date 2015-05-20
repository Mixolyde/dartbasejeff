library board_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('board instance tests', () {
    test('new board is open', () {
      Board board = new Board();
      expect(board.isClosed, isFalse);
    });
    test('new board has no played cards', () {
      Board board = new Board();
      expect(board.count, 0);
    });
    test('play normal card', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);

      expect(board.count, 1);
    });
    test('can\'t play on played spot', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isFalse);
      expect(board.count, 1);
    });
    test('play normal card in non-origin', () {
      Board board = new Board();
      expect(board.playCardToStation(const BoardLoc(5, 4), Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 1);
      expect(board.playCardToStation(const BoardLoc(5, 3), Card.pow, CardDirection.up, 1), isFalse);
      expect(board.count, 1);
      expect(board.playCardToStation(const BoardLoc(1, 0), Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 2);
    });
  });
  
  group('is legal move', () {
    test('first non-sab card is always legal move', () {
      Board board = new Board();
      expect(board.isLegalMove(BoardLoc.origin, Card.hab, CardDirection.up), isTrue);
      expect(board.isLegalMove(const BoardLoc(5,4), Card.hab, CardDirection.up), isTrue);

    });
    test('legal cap card placement next to power station', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 1);
      
      // for each possible direction of played card from existing card
      for(CardDirection neighborDir in CardUtil.allDirections){
        var playedLoc = BoardLoc.origin.neighborLoc(neighborDir);
        // for each possible facing direction of played card
        for(CardDirection playedDir in CardUtil.allDirections){
          if(playedDir == CardUtil.opposite(neighborDir)){
            expect(board.isLegalMove(playedLoc, Card.rec, playedDir, 1), isTrue);
          } else {
            expect(board.isLegalMove(playedLoc, Card.rec, playedDir, 1), isFalse);
          }
        }
      }
    });
    test('legal pow card placement next to cap', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.rec, CardDirection.up, 1), isTrue);
      expect(board.count, 1);
      
      // for each possible direction of played card from existing card
      for(CardDirection neighborDir in CardUtil.allDirections){
        var playedLoc = BoardLoc.origin.neighborLoc(neighborDir);
        // for each possible facing direction of played card
        for(CardDirection playedDir in CardUtil.allDirections){
          if(neighborDir == CardDirection.up){
            expect(board.isLegalMove(playedLoc, Card.pow, playedDir, 1), isTrue);
          } else {
            expect(board.isLegalMove(playedLoc, Card.pow, playedDir, 1), isFalse);
          }
        }
      }
    });
  });

  group('board utility tests', () {
    test('illegal sabotage locs', () {
      Board board = new Board();
      expect(board.isLegalSabotage(BoardLoc.origin), isFalse);
      expect(board.isLegalSabotage(const BoardLoc(1, 1)), isFalse);
    });
    test('sabotage is illegal move on empty board', () {
      Board board = new Board();
      expect(board.isLegalMove(BoardLoc.origin, Card.sab, CardDirection.up), isFalse);
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
      var pc = const PlayedCard(Card.com, CardDirection.down, 1);
      expect(pc.exits().length, 1);
      expect(pc.exits(), contains(CardDirection.down));
    });

    test('POW played card exits', () {
      var pc = const PlayedCard(Card.pow, CardDirection.down, 1);
      expect(pc.exits().length, 4);
      expect(pc.exits(), contains(CardDirection.down));
      expect(pc.exits(), contains(CardDirection.up));
      expect(pc.exits(), contains(CardDirection.left));
      expect(pc.exits(), contains(CardDirection.right));
    });
  });
}
