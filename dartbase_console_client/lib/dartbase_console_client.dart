// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_console_client library.
library dartbase_console_client;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:console/console.dart';
import 'package:dartbase_server/gamelogic.dart';

part 'console.dart';
part 'print.dart';

class LocalConsoleClient {
  final int numPlayers;
  Game _game;
  int activePlayer = 1;
  LocalConsoleClient(this.numPlayers){
    log("Initializing Local Console Client Game.");
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

    //default keybindings for all modes
    Keyboard.init();

    Keyboard.bindKeys(["b", "B"]).listen((_) {
      print("Board");
    });

    Keyboard.bindKeys(["d", "D"]).listen((_) {
      print("Deferred piles");
    });

    Keyboard.bindKeys(["h", "H"]).listen((_) {
      print(getCardList(_game.round.roundData[1].hand));
    });

    Keyboard.bindKeys(["p", "P"]).listen((_) {
      print("Player data");
    });

    Keyboard.bindKeys(["q", "Q"]).listen((_) {
      endClient();

    });

    Keyboard.bindKey("?").listen((_) {
      print(getInstructions());
    });
  }

  void endClient(){
    log("Quitting game.");
    exit(0);

  }

  GameState get gameState => _game.gameState;

}


