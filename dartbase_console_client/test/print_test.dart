// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library print.test;

import 'dart:math';
import 'package:dartbase_console_client/dartbase_console_client.dart';
import 'package:test/test.dart';

import 'package:dartbase_server/gamelogic.dart';

void main() {
  group('instructions print tests', () {
    test('print instructions', () {
      var inst = getInstructions();
      print(inst);
      expect(inst.contains("arrows"), isTrue);
    });
  });
  group('get game data group', () {
    test('2 player game data', () {
      Game game = createSeededGame(2);
      var data = getGameData(game);
      print(data);
      expect(data.contains("Player Count: 2"), isTrue);
      expect(data.contains("Current Pot: 0"), isTrue);
      expect(data.contains("make_selections"), isTrue);
    });
    test('4 player game data', () {
      Game game = createSeededGame(4);
      var data = getGameData(game);
      print(data);
      expect(data.contains("Player Count: 4"), isTrue);
      expect(data.contains("Current Pot: 0"), isTrue);
      expect(data.contains("make_selections"), isTrue);
    });
  });
  group('get player data group', () {
    test('2 player player data', () {
      Game game = createSeededGame(2);
      game.round.roundData[1].deferred.add(Card.rec);
      var data = getPlayerData(game);
      print(data);
      expect(data.contains("Player Number: 1"), isTrue);
      expect(data.contains("Player Number: 2"), isTrue);
      expect(data.contains("Player Number: 3"), isFalse);
      expect(data.contains("Player Number: 4"), isFalse);
      expect(data.contains("Player Name: TestPlayer1"), isTrue);
      expect(data.contains("Player Name: TestPlayer2"), isTrue);
      expect(data.contains("Player Name: TestPlayer3"), isFalse);
      expect(data.contains("Player Name: TestPlayer4"), isFalse);
      expect(data.contains("Player Cash: 50"), isTrue);
      expect(data.contains("Deferred Cards: Rec"), isTrue);
      expect(data.contains("Player2 has no Deferred Cards"), isTrue);
    });
    test('4 player data', () {
      Game game = createSeededGame(4);
      var data = getPlayerData(game);
      print(data);
      expect(data.contains("Player Number: 1"), isTrue);
      expect(data.contains("Player Number: 2"), isTrue);
      expect(data.contains("Player Number: 3"), isTrue);
      expect(data.contains("Player Number: 4"), isTrue);
      expect(data.contains("Player Name: TestPlayer1"), isTrue);
      expect(data.contains("Player Name: TestPlayer2"), isTrue);
      expect(data.contains("Player Name: TestPlayer3"), isTrue);
      expect(data.contains("Player Name: TestPlayer4"), isTrue);
      expect(data.contains("Player Cash: 50"), isTrue);
      expect(data.contains("Player1 has no Deferred Cards"), isTrue);
      expect(data.contains("Player2 has no Deferred Cards"), isTrue);
      expect(data.contains("Player3 has no Deferred Cards"), isTrue);
      expect(data.contains("Player4 has no Deferred Cards"), isTrue);
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
