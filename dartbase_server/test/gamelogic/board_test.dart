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
            expect(board.isLegalMove(playedLoc, Card.rec, playedDir), isTrue);
          } else {
            expect(board.isLegalMove(playedLoc, Card.rec, playedDir), isFalse);
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
            expect(board.isLegalMove(playedLoc, Card.pow, playedDir), isTrue);
          } else {
            expect(board.isLegalMove(playedLoc, Card.pow, playedDir), isFalse);
          }
        }
      }
    });
    test('legal card placement with three neighbor with three exits', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 1);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
          .neighborLoc(CardDirection.right),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
          .neighborLoc(CardDirection.right).neighborLoc(CardDirection.up),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 5);

      BoardLoc testLoc = BoardLoc.origin.neighborLoc(CardDirection.right);

      for(CardDirection testDir in CardUtil.allDirections){
        expect(board.isLegalMove(testLoc, Card.pow, testDir), isTrue);
        expect(board.isLegalMove(testLoc, Card.rec, testDir), isFalse);
        expect(board.isLegalMove(testLoc, Card.lab, testDir), isFalse);
        expect(board.isLegalMove(testLoc, Card.fac, testDir), isFalse);

        if(testDir == CardDirection.up){
          expect(board.isLegalMove(testLoc, Card.hab, testDir), isTrue);
        } else {
          expect(board.isLegalMove(testLoc, Card.hab, testDir), isFalse);
        }
      }
    });
    test('legal card placement with three neighbor with two exits', () {
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 1);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right),
          Card.fac, CardDirection.left, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
          .neighborLoc(CardDirection.right),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
          BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
          .neighborLoc(CardDirection.right).neighborLoc(CardDirection.up),
          Card.pow, CardDirection.up, 1), isTrue);
      expect(board.count, 5);

      BoardLoc testLoc = BoardLoc.origin.neighborLoc(CardDirection.right);

      for(CardDirection testDir in CardUtil.allDirections){
        expect(board.isLegalMove(testLoc, Card.pow, testDir), isFalse);
        expect(board.isLegalMove(testLoc, Card.rec, testDir), isFalse);
        expect(board.isLegalMove(testLoc, Card.lab, testDir), isFalse);

        if(testDir == CardDirection.left || testDir == CardDirection.right){
          expect(board.isLegalMove(testLoc, Card.fac, testDir), isTrue);
        } else {
          expect(board.isLegalMove(testLoc, Card.fac, testDir), isFalse);
        }

        if(testDir == CardDirection.down){
          expect(board.isLegalMove(testLoc, Card.hab, testDir), isTrue);
        } else {
          expect(board.isLegalMove(testLoc, Card.hab, testDir), isFalse);
        }
      }
    });
  });

  group('board isClosed tests', () {
    test('board with any one card is open', () {
      CardUtil.allCards.foreach((card) {
        Board board = new Board();
        board.playCardToStation(BoardLoc.origin, card, CardDirection.up, 1);
        expect(board.isClosed, isFalse);
      });
    });
    test('two facing caps are closed', () {
      Board board = new Board();
      board.playCardToStation(BoardLoc.origin, Card.com, CardDirection.up, 1);
      expect(board.isClosed, isFalse);
      board.playCardToStation(BoardLoc.origin.neighborLoc(CardDirection.up),
          Card.com, CardDirection.down, 1);
      expect(board.count, 2);
      expect(board.isClosed, isTrue);
    });
    test('plus shape is closed', () {
      Board board = new Board();
      board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1);
      expect(board.isClosed, isFalse);
      board.playCardToStation(BoardLoc.origin.neighborLoc(CardDirection.up),
          Card.com, CardDirection.down, 1);
      expect(board.isClosed, isFalse);
      board.playCardToStation(BoardLoc.origin.neighborLoc(CardDirection.down),
          Card.com, CardDirection.up, 1);
      expect(board.isClosed, isFalse);
      board.playCardToStation(BoardLoc.origin.neighborLoc(CardDirection.left),
          Card.com, CardDirection.right, 1);
      expect(board.isClosed, isFalse);
      board.playCardToStation(BoardLoc.origin.neighborLoc(CardDirection.right),
          Card.com, CardDirection.left, 1);
      expect(board.isClosed, isTrue);
    });
  });

  group('board utility tests', () {
    test('sabotage is legal move on empty board', () {
      Board board = new Board();
      expect(board.isLegalMove(BoardLoc.origin, Card.sab, CardDirection.up), isTrue);
      expect(board.isLegalMove(const BoardLoc(1, 1), Card.sab, CardDirection.up), isTrue);
    });
    test('sabotage legal board loc checks', () {
      Board board = new Board();
      //play two cards
      board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1);
      board.playCardToStation(const BoardLoc(1, 0), Card.pow, CardDirection.up, 1);

      expect(board.isLegalMove(BoardLoc.origin, Card.sab, CardDirection.up), isTrue);
      expect(board.isLegalMove(const BoardLoc(1, 1), Card.sab, CardDirection.up), isFalse);
      expect(board.isLegalMove(const BoardLoc(1, 0), Card.sab, CardDirection.up), isTrue);
      expect(board.isLegalMove(const BoardLoc(0, 1), Card.sab, CardDirection.up), isFalse);
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
