// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

@red.Route("/games")
Map getGameList() {
  log("Getting game list");
  Map gameList = {};
  try {
    gameList['gameids'] = [1];
  } catch (e) {
    log("Error getting game list: $e");
  }
  return gameList;
}

@red.Route("/games", methods: const [red.POST])
Map newGame(@red.Body(red.JSON) Map players){
  log("Creating new game resource with player data: " + players.toString());
  Map result = {};
  result['gameid'] = GameSupervisor.newGame(players);

  log("Returning result map: " + result.toString());

  return result;
}

@red.Route("/games/:gameid")
Map getGameData(int gameid){
  log("Getting data for game " + gameid.toString());
  Map gameDataMap = {};
  try {
    gameDataMap['gameid'] = gameid;
    gameDataMap['playerids'] = [1, 2, 3, 4];
  } catch (e) {
    log("Error getting PlayerData For Game " + gameid.toString() + ": $e");
  }
  return gameDataMap;
}

@red.Route("/games/:gameid/playerdata/:playerid")
Map getPlayerDataForGame(int gameid, int playerid) {
  log("Getting player " + playerid.toString() + " data for game " + gameid.toString());
  Map gameDataMap = {};
  try {
    gameDataMap['gameid'] = gameid;
    gameDataMap['playerid'] = playerid;
  } catch (e) {
    log("Error getting PlayerData For Game " + gameid.toString() + ": $e");
  }
  return gameDataMap;
}
