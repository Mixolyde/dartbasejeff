library game_test;

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
  group('round tests', () {
    test('round data init', () {
      Player p1 = new Player(1, "Brian");
      Player p2 = new Player(2, "Brian2");

      Round round = new Round([p1, p2]);

      expect(round.pot, 0);
      expect(round.turnCount, 1);
      expect(round.roundData.keys.length, 2);
      expect(round.board.count, 0);
      expect(round.selections.keys.length, 0);

    });
  });
  group('player round data tests', () {
    test('player round data init', () {
      Player p1 = new Player(1, "Brian");
      PlayerRoundData data = new PlayerRoundData(p1);

      expect(data.hand.length, 5);
      expect(data.deferred.length, 0);
      expect(data.deck.length, 15);
    });
  });
}
