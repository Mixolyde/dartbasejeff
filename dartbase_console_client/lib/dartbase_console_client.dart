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
part 'print_cards.dart';

class LocalConsoleClient {
  final int numPlayers;
  Game _game;
  int activePlayer = 1;
  int activeHandSelection = 0;
  bool isInteractive;

  LocalConsoleClient(this.numPlayers, {this.isInteractive: true}){
    log("Initializing Local Console Client Game. Interactive Mode: $isInteractive.");
    _game = new Game();
    for (var i = 1; i <= numPlayers; i++) {
      _game.addPlayer("Player${i}");
    }
    _game.startGame();

    if(isInteractive){
      initKeyboard();
    }

    print(getInstructions());

    print(getCardList(_game.round.roundData[1].hand, highlight: activeHandSelection));

  }

  void initKeyboard(){

    //default keybindings for all modes
    Keyboard.init();

    Keyboard.bindKeys(["<", ","]).listen((_) {
      this.activeHandSelection -= 1;
      this.activeHandSelection = this.activeHandSelection % _game.round.roundData[1].hand.length;
      print(getCardList(_game.round.roundData[1].hand, highlight: activeHandSelection));
    });

    Keyboard.bindKeys([">", "."]).listen((_) {
      this.activeHandSelection += 1;
      this.activeHandSelection = this.activeHandSelection % _game.round.roundData[1].hand.length;
      print(getCardList(_game.round.roundData[1].hand, highlight: activeHandSelection));
    });

    Keyboard.bindKeys(["b", "B"]).listen((_) {
      print("Board");
    });

    Keyboard.bindKeys(["g", "G"]).listen((_) {
      print(getGameData(_game));
    });

    Keyboard.bindKeys(["h", "H"]).listen((_) {
      print(getCardList(_game.round.roundData[this.activePlayer].hand, highlight: activeHandSelection));
    });

    Keyboard.bindKeys(["p", "P"]).listen((_) {
      print(getPlayerData(_game));
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
