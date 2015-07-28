// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_console_client library.
library dartbase_console_client;

import 'package:console/console.dart';
import 'package:dartbase_server/gamelogic.dart';

part 'print.dart';

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


