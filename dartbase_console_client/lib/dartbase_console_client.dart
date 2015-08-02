// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_console_client library.
library dartbase_console_client;

import 'dart:async';
import 'dart:io';
import 'package:console/console.dart';
import 'package:dartbase_server/gamelogic.dart';

part 'console.dart';
part 'print.dart';

class LocalConsoleClient {
  Timer keepAliveTimer;
  final int numPlayers;
  Game _game;
  int activePlayer = 1;
  LocalConsoleClient(this.numPlayers){
//    keepAliveTimer = new Timer.periodic(new Duration(seconds:2), (timer){
//
//    });
    _game = new Game();
    for (var i = 1; i <= numPlayers; i++) {
      _game.addPlayer("Player${i}");
    }
    _game.startGame();

    initKeyboard();

    print(getInstructions());

    print(getCardList(_game.round.roundData[1].hand));

  }

  void initKeyboard(){
    Keyboard.init();

    Keyboard.bindKeys(["q", "Q"]).listen((_) {
      endClient();
      exit(0);
    });

    Keyboard.bindKey("?").listen((_) {
      print(getInstructions());
    });
  }

  void endClient(){
    print("Quitting game.");
    //keepAliveTimer.cancel();

  }

  GameState get gameState => _game.gameState;

}


