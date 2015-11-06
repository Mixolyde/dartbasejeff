// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

final GameSupervisor _gameSuper = new GameSupervisor._singleton();

class GameSupervisor {
  List<WebGame> _games;
  static final int MAX_GAMES = 2;
  static int _currentid = 0;

  GameSupervisor._singleton() {
    log("Constructing GameSupervisor");
    _games = [];
  }

  static int newGame(Map players){
    log("Received request for new game with player data: " + players.toString());
    if(_gameSuper._games.length < MAX_GAMES){
      log("Creating new game with player data: " + players.toString());
      _currentid++;
      WebGame webGame = new WebGame(_currentid, new Game());
      //TODO add players
      _gameSuper._games.add(webGame);
      log("Returning gameid: ${_currentid}");

      return _currentid;    
      
    } else {
      log("Max simultaneous games already reached.");
      throw new red.ErrorResponse(400, {"error": "Max Games Reached"});
    }

  }

  static int gameCount(){
    return _gameSuper._games.length;
  }

  static void clearGames(){
    log("Clearing games from GameSupervisor");
    _gameSuper._games.clear();
    _currentid = 0;
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
