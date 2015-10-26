// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

final GameSupervisor _gameSuper = new GameSupervisor._singleton();

class GameSupervisor {
  List<Game> _games;

  GameSupervisor._singleton() {
    log("Constructing GameSupervisor");
    _games = [];
  }

  static int newGame(Map players){
    if(_gameSuper._games.length == 0){
      log("Creating new game with player data: " + players.toString());
      Game game = new Game();
      //TODO add players
      _gameSuper._games.add(game);
    }
    log("Returning gameid: 1");

    return 1;
  }
}
