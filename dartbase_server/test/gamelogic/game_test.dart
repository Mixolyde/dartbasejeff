library game_test;

import 'dart:math';
import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('game tests', () {
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
      game.round.makeSelection(
          game.players[0], game.round.roundData[game.players[0]].hand[0]);
      game.round.makeSelection(
          game.players[1], game.round.roundData[game.players[1]].hand[0]);
      game.round.makeSelection(
          game.players[2], game.round.roundData[game.players[2]].hand[1]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 3);
      expect(game.round.activePlayer, null);

    });
    test('make all deferred selections same card', () {
      Game game = createSeededGame(4);

      //all four seeded hands have a lab
      game.round.makeSelection(
          game.players[0], game.round.roundData[game.players[0]].hand[3]);
      game.round.makeSelection(
          game.players[1], game.round.roundData[game.players[1]].hand[3]);
      game.round.makeSelection(
          game.players[2], game.round.roundData[game.players[2]].hand[3]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 1);

      //finish selection round
      game.round.makeSelection(
          game.players[3], game.round.roundData[game.players[3]].hand[2]);

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
      game.round.makeSelection(
          game.players[0], game.round.roundData[game.players[0]].hand[1]);
      game.round.makeSelection(
          game.players[1], game.round.roundData[game.players[1]].hand[2]);
      game.round.makeSelection(
          game.players[2], game.round.roundData[game.players[2]].hand[3]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 2);

      //finish selection round
      game.round.makeSelection(
          game.players[3], game.round.roundData[game.players[3]].hand[2]);

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
    test('make no deferred selections', () {
      Game game = createSeededGame(4);

      //two coms and two labs
      game.round.makeSelection(
          game.players[0], game.round.roundData[game.players[0]].hand[0]);
      game.round.makeSelection(
          game.players[1], game.round.roundData[game.players[1]].hand[0]);
      game.round.makeSelection(
          game.players[2], game.round.roundData[game.players[2]].hand[1]);

      expect(game.round.roundState, RoundState.make_selections);
      expect(game.round.selections.keys.length, 3);

      //finish selection round
      game.round.makeSelection(
          game.players[3], game.round.roundData[game.players[3]].hand[1]);

      //should move all selections to deferred, draw a card and reset round to next turn
      expect(game.round.roundState, RoundState.play_card);
      expect(game.round.selections.keys.length, 4);
      expect(game.round.turnCount, 1);
      expect(game.round.activePlayer, game.players[3]);
      expect(game.round.roundData.keys.every((player) {
        return game.round.roundData[player].hand.length == 5 &&
        game.round.roundData[player].deferred.length == 1 &&
        game.round.roundData[player].deck.length == 14;
      }), isTrue);

    });

  });
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
}

Game createSeededGame(int numPlayers){
  serverRandom = new Random(0);
  //player hands:
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
