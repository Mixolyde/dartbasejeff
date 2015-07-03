library round_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

import 'game_test.dart' as game_test;

void main() {
  group('player round data tests', () {
    test('first player round data init', () {
      Player p1 = new Player(1, "Brian");
      PlayerRoundData data = new PlayerRoundData(p1);

      expect(data.hand.length, 5);
      expect(data.deferred.length, 0);
      expect(data.deck.length, 15);
    });
    test('two player round data init', () {
      Player p1 = new Player(1, "Brian");
      Player p2 = new Player(2, "Brian2");

      Round round = new Round([p1, p2]);

      expect(round.pot, 0);
      expect(round.turnCount, 1);
      expect(round.roundData.keys.length, 2);
      expect(round.board.count, 0);
      expect(round.selections.keys.length, 0);
      expect(round.activePlayer, null);
    });
  });

  group('play card tests', () {
    test('invalid play tests', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select cap
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select cap
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //wrong player
      expect(game.round.playCard(p1, Card.rec, BoardLoc.origin, CardDirection.up), isFalse);
      //card not deferred
      expect(game.round.playCard(p0, Card.pow, BoardLoc.origin, CardDirection.up), isFalse);
    });
    test('play cap test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select com
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play cap
      expect(game.round.playCard(p0, Card.com, BoardLoc.origin, CardDirection.up), isTrue);

      expect(game.round.roundState, RoundState.play_card);
      expect(game.round.board.count, 1);
      expect(game.round.activePlayer, p1);
      expect(game.round.pot, 0);
      expect(game.round.activePlayer.cash, 50);
    });
    test('play lab test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select lab
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[2]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play cap
      expect(game.round.playCard(p0, Card.lab, BoardLoc.origin, CardDirection.up), isTrue);

      expect(game.round.roundState, RoundState.play_card);
      expect(game.round.board.count, 1);
      expect(game.round.activePlayer, p1);
      expect(game.round.pot, 1);
      expect(game.round.activePlayer.cash, 50);
      expect(game.round.roundData[p0.playerNum].player.cash, 49);
      expect(game.round.turnCount, 1);
    });
  });
  group('complete turn tests', () {
    test('play lab then cap test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select lab
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[2]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play lab
      expect(game.round.playCard(p0, Card.lab, BoardLoc.origin, CardDirection.up), isTrue);
      //play cap
      expect(game.round.playCard(p1, Card.rec, BoardLoc.origin.neighborLoc(CardDirection.up),
          CardDirection.down), isTrue);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.board.count, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 49);
      expect(game.round.roundData[p1.playerNum].player.cash, 51);
      expect(game.round.turnCount, 2);
    });
    test('both players are unplayable test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];

      // test board:
      // +--+
      // |  |
      // +-
      game.round.board.playCardToStation(BoardLoc.origin, Card.lab, CardDirection.up, 1);
      game.round.board.playCardToStation(const BoardLoc(0, 1), Card.lab, CardDirection.right, 1);
      game.round.board.playCardToStation(const BoardLoc(1, 1), Card.lab, CardDirection.down, 1);
      //select com
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      //all players have all unplayable deferred cards, turn ends
      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.board.count, 3);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 50);
      expect(game.round.roundData[p1.playerNum].player.cash, 50);
      expect(game.round.turnCount, 2);
    });
  test('first player makes second player unplayable test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];

      // test board:
      // +-
      // |
      // +-
      game.round.board.playCardToStation(BoardLoc.origin, Card.lab, CardDirection.up, 1);
      game.round.board.playCardToStation(const BoardLoc(0, 1), Card.lab, CardDirection.right, 1);
      //game.round.board.playCardToStation(const BoardLoc(1, 1), Card.lab, CardDirection.down, 1);
      //select lab
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[2]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      //play lab
      expect(game.round.playCard(p0, Card.lab, const BoardLoc(1, 1), CardDirection.down), isTrue);

      //all players have all unplayable deferred cards, turn ends
      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.board.count, 3);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 1);
      expect(game.round.roundData[p0.playerNum].player.cash, 49);
      expect(game.round.roundData[p1.playerNum].player.cash, 50);
      expect(game.round.turnCount, 2);
    });
  });

  group('end of round tests', () {
    test('play two caps to empty board test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select com
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play cap 1
      expect(game.round.playCard(p0, Card.com, BoardLoc.origin, CardDirection.up), isTrue);
      //play cap 2
      expect(game.round.playCard(p1, Card.rec, const BoardLoc(0, 1), CardDirection.down), isTrue);

      expect(game.round.roundState, RoundState.round_over);
      expect(game.round.board.count, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 50);
      expect(game.round.roundData[p1.playerNum].player.cash, 50);
    });
  });
  group('end of game tests', () {
    test('player has exact cost of lab left test', () {
      //two player game for shorter tests
      Game game = game_test.createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];

      //set player's cash to cost of lab
      p0.cash = 1;
      //select lab
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[2]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play lab
      expect(game.round.playCard(p0, Card.lab, BoardLoc.origin, CardDirection.up), isTrue);

      expect(game.round.roundState, RoundState.game_over);
      expect(game.round.board.count, 1);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 1);
      expect(game.round.roundData[p0.playerNum].player.cash, 0);
      expect(game.round.roundData[p1.playerNum].player.cash, 50);
      expect(game.round.turnCount, 1);
    });
  });
}