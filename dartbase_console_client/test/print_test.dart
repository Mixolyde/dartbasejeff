// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library print.test;

import 'package:dartbase_console_client/dartbase_console_client.dart';
import 'package:unittest/unittest.dart';

import 'package:dartbase_server/gamelogic.dart';

void main() {
  test('print empty board', () {
    Board board = new Board();
    var result = printBoard(board, BoardLoc.origin, 1, 1);
    expect(result, "Board Empty");
    
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

    var result = printBoard(board, BoardLoc.origin, 1, 1);
  });

}
