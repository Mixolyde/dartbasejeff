// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_console_client library.
library dartbase_console_client;

import 'package:console/console.dart';
import 'package:dartbase_server/gamelogic.dart';

class LocalConsoleClient {
  final int numPlayers;
  Game _game;
  LocalConsoleClient(this.numPlayers){
    _game = new Game();
    for (var i = 1; i <= numPlayers; i++) {
      _game.addPlayer("Player${i}");
    }
    _game.startGame();

  }

}

void printBoard(Board board, BoardLoc viewLoc){
  var canvas = new Canvas(120, 48);

  if(board.contains(viewLoc)){
    _drawLoc(canvas, board[viewLoc], 60, 25);
  }

  print(canvas.frame());
}

void _drawLoc(Canvas canvas, PlayedCard pc, int viewX, int viewY){
  canvas.set(viewX, viewY);
}
