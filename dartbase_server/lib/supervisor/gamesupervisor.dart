// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

final GameSupervisor _gameSuper = new GameSupervisor._singleton();

class GameSupervisor {
  List<WebGame> _games;
  final int MAX_GAMES = 2;
  int currentid = 0;

  GameSupervisor._singleton() {
    log("Constructing GameSupervisor");
    _games = [];
  }

  static int newGame(Map players){
    if(_gameSuper._games.length < MAX_GAMES){
      log("Creating new game with player data: " + players.toString());
      currentid++;
      WebGame webGame = new WebGame();
      webGame.game = new Game();
      webGame.gameid = currentid;
      //TODO add players
      _gameSuper._games.add(game);
      log("Returning gameid: ${currentid}");

      return currentid;    
      
    } else {
      log("Max simultaneous games already reached.");
      throw new app.ErrorResponse(400, {"error": "Max Games Reached"});
    }

  }
}

class WebGame {
  int gameid;
  Game game;
  final DateTime created = new DateTime.now();
  DateTime modified = new DateTime.now();
  
  WebGame(this.gameid, this.game);
  
  Map getGameData(){
    Map gameDataMap = {};
    
    return gameDataMap;
  }
}
