library game_test;

import 'dart:math';
import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('new game tests', () {
    test('game data init', () {
      Game game = new Game();

      expect(game.isStarted, isFalse);
      expect(game.round, isNull);
      expect(game.players.length, 0);
    });
    test('game add players', () {
      Game game = new Game();

      expect(game.addPlayer("Brian"), isTrue);
      expect(game.players.length, 1);
      expect(game.addPlayer("Brian"), isTrue);
      expect(game.addPlayer("Brian"), isTrue);
      expect(game.addPlayer("Brian"), isTrue);
      expect(game.players.length, 4);

      expect(game.addPlayer("Brian"), isFalse);
      expect(game.players.length, 4);

      expect(game.isStarted, isFalse);
    });
    test('start game', () {
      Game game = new Game();

      expect(game.addPlayer("Brian"), isTrue);
      expect(game.players.length, 1);
      expect(game.startGame(), isFalse);

      expect(game.addPlayer("Brian"), isTrue);
      expect(game.addPlayer("Brian"), isTrue);
      expect(game.players.length, 3);
      expect(game.startGame(), isTrue);
      expect(game.startGame(), isTrue);

      //can't add a player after starting
      expect(game.addPlayer("Brian"), isFalse);
      expect(game.players.length, 3);
      expect(game.startGame(), isTrue);

      expect(game.isStarted, isTrue);
    });
  });
  group('make card selections', () {
    test('make some selections', () {
      //pick first card from 3/4 player's hands
      Game game = createSeededGame(4);
      game.makeSelection(game.players[0], game.round.roundData[game.players[0].playerNum].hand[0]);
      game.makeSelection(game.players[1], game.round.roundData[game.players[1].playerNum].hand[0]);
      game.makeSelection(game.players[2], game.round.roundData[game.players[2].playerNum].hand[1]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 3);
      expect(game.round.activePlayer, null);
    });
    test('make all deferred selections same card', () {
      Game game = createSeededGame(4);

      //all four seeded hands have a lab
      game.makeSelection(game.players[0], game.round.roundData[game.players[0].playerNum].hand[3]);
      game.makeSelection(game.players[1], game.round.roundData[game.players[1].playerNum].hand[3]);
      game.makeSelection(game.players[2], game.round.roundData[game.players[2].playerNum].hand[3]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 1);

      //finish selection round
      game.makeSelection(game.players[3], game.round.roundData[game.players[3].playerNum].hand[2]);

      //should move all selections to deferred, draw a card and reset round to next turn
      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 0);
      expect(game.round.turnCount, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.roundData.keys.every((player) {
        return game.round.roundData[player].hand.length == 5 &&
            game.round.roundData[player].deferred.length == 1 &&
            game.round.roundData[player].deck.length == 14;
      }), isTrue);
    });
    test('make all deferred selections two pairs of cards', () {
      Game game = createSeededGame(4);

      //two coms and two labs
      game.makeSelection(game.players[0], game.round.roundData[game.players[0].playerNum].hand[1]);
      game.makeSelection(game.players[1], game.round.roundData[game.players[1].playerNum].hand[2]);
      game.makeSelection(game.players[2], game.round.roundData[game.players[2].playerNum].hand[3]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 2);

      //finish selection round
      game.makeSelection(game.players[3], game.round.roundData[game.players[3].playerNum].hand[2]);

      //should move all selections to deferred, draw a card and reset round to next turn
      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 0);
      expect(game.round.turnCount, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.roundData.keys.every((playerNum) {
        return game.round.roundData[playerNum].hand.length == 5 &&
            game.round.roundData[playerNum].deferred.length == 1 &&
            game.round.roundData[playerNum].deck.length == 14;
      }), isTrue);
    });
    test('make no deferred selections', () {
      Game game = createSeededGame(4);

      //two coms and two labs
      game.makeSelection(game.players[0], game.round.roundData[game.players[0].playerNum].hand[0]);
      game.makeSelection(game.players[1], game.round.roundData[game.players[1].playerNum].hand[0]);
      game.makeSelection(game.players[2], game.round.roundData[game.players[2].playerNum].hand[1]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 3);

      //finish selection round
      game.makeSelection(game.players[3], game.round.roundData[game.players[3].playerNum].hand[1]);

      //should move all selections to deferred, draw a card and reset round to next turn
      expect(game.round.roundState, RoundState.play_card);
      expect(game.round.selections.keys.length, 4);
      expect(game.round.turnCount, 1);
      expect(game.round.activePlayer, game.players[3]);
      expect(game.round.activePlayer == game.players[3], isTrue);
      expect(game.round.activePlayer == game.players[0], isFalse);
      expect(game.round.roundData.keys.every((playerNum) {
        return game.round.roundData[playerNum].hand.length == 5 &&
            game.round.roundData[playerNum].deferred.length == 1 &&
            game.round.roundData[playerNum].deck.length == 14;
      }), isTrue);
    });
  });

  group('end of round tests', () {
    test('play two caps to empty board test', () {
      //two player game for shorter tests
      Game game = createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];
      //select com
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play cap 1
      expect(game.playCard(p0, Card.com, BoardLoc.origin, CardDirection.up), isTrue);
      //play cap 2
      expect(game.playCard(p1, Card.rec, const BoardLoc(0, 1), CardDirection.down), isTrue);

      expect(game.round.roundState, RoundState.round_over);
      expect(game.round.board.count, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 50);
      expect(game.round.roundData[p1.playerNum].player.cash, 50);

      expect(game.gameState, GameState.started);
    });
    test('reset round after closed board test', () {
      //two player game for shorter tests
      Game game = createSeededGame(2);
      Player p0 = game.players[0];
      Player p1 = game.players[1];

      expect(game.resetRound(), isFalse);

      game.round.pot = 10;

      //select com
      game.round.makeSelection(p0, game.round.roundData[p0.playerNum].hand[0]);
      //select rec
      game.round.makeSelection(p1, game.round.roundData[p1.playerNum].hand[0]);

      expect(game.round.activePlayer, p0);

      //play cap 1
      expect(game.playCard(p0, Card.com, BoardLoc.origin, CardDirection.up), isTrue);
      //play cap 2
      expect(game.playCard(p1, Card.rec, const BoardLoc(0, 1), CardDirection.down), isTrue);

      expect(game.round.roundState, RoundState.round_over);
      expect(game.round.board.count, 2);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 51);
      expect(game.round.roundData[p1.playerNum].player.cash, 59);

      expect(game.resetRound(), isTrue);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.board.count,0);
      expect(game.round.activePlayer, null);
      expect(game.round.pot, 0);
      expect(game.round.roundData[p0.playerNum].player.cash, 51);
      expect(game.round.roundData[p1.playerNum].player.cash, 59);
    });
  });

  group('end of game tests', () {
    test('player has exact cost of lab left test', () {
      //two player game for shorter tests
      Game game = createSeededGame(2);
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
      expect(game.playCard(p0, Card.lab, BoardLoc.origin, CardDirection.up), isTrue);

      expect(game.gameState, GameState.ended);
    });
  });
}

Game createSeededGame(int numPlayers) {
  serverRandom = new Random(0);
  //4 player hands:
  //com, com, lab, lab, sab
  //rec, doc, com, lab, fac
  //rec, doc, doc, lab, sab
  //com, lab, lab, fac, pow

  Game game = new Game();
  for (var i = 1; i <= numPlayers; i++) {
    game.addPlayer("TestPlayer${i}");
  }
  game.startGame();
  return game;
}
