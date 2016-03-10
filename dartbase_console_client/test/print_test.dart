// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library print.test;

import 'package:dartbase_console_client/dartbase_console_client.dart';
import 'package:test/test.dart';

import 'package:dartbase_server/gamelogic.dart';

void main() {
  group('board print tests', () {
    test('print empty board', () {
      Board board = new Board();
      var result = getBoard(board, BoardLoc.origin, 1, 1);
      expect(result, "Empty Board");

    });
    test('print board', () {
      // test board:
      // +--=--+ 1 3 2
      // |     |
      // +--=--+ 2 3 3
      Board board = new Board();
      expect(board.playCardToStation(BoardLoc.origin, Card.pow, CardDirection.up, 1), isTrue);
      expect(board.playCardToStation(
      BoardLoc.origin.neighborLoc(CardDirection.down),
      Card.pow, CardDirection.up, 2), isTrue);
      expect(board.playCardToStation(
      BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right),
      Card.fac, CardDirection.left, 3), isTrue);
      expect(board.playCardToStation(
      BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
      .neighborLoc(CardDirection.right),
      Card.pow, CardDirection.up, 3), isTrue);
      expect(board.playCardToStation(
      BoardLoc.origin.neighborLoc(CardDirection.down).neighborLoc(CardDirection.right)
      .neighborLoc(CardDirection.right).neighborLoc(CardDirection.up),
      Card.pow, CardDirection.up, 2), isTrue);
      expect(board.playCardToStation(
      BoardLoc.origin.neighborLoc(CardDirection.right),
      Card.fac, CardDirection.left, 3), isTrue);

      var result = getBoard(board, BoardLoc.origin, 1, 1);
    });
  });
  group('card print tests', () {
    test('print card list', () {
      expect(getCardList(new List<Card>.from([])), "Empty");

      String hand = getCardList(new List<Card>.from([Card.rec, Card.lab, Card.fac, Card.hab, Card.pow, Card.sab]));
      print(hand);
      expect(hand.contains("| O | | O-| | O | |-O-| |-O-| |-*-|"), true);
      expect(hand.contains("Rec   Lab   Fac   Hab   Pow   Sab"), true);
      expect(hand.contains("   0     3     4     5     6     7"), true);
      expect(hand.contains("  -1     1     1     2     3     1"), true);

    });
  });
  group('instructions print tests', () {
    test('print instructions', () {
      var inst = getInstructions();
      print(inst);
      expect(inst.contains("arrows"), isTrue);

    });
  });
}
