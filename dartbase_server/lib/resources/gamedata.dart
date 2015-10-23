// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

@app.Route("/game")
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
@app.Route("/game/:gameid/playerdata/:playerid")
Map getPlayerDataForGame(int gameid, int playerid) {
  log("Getting player " + playerid.toString() + " data for game " + gameid.toString());
  Map gameDataMap = {};
  try {
    gameDataMap['gameid'] = gameid;
    gameDataMap['playerid'] = playerid;
  } catch (e) {
    log("Error getting PlayerData For Game " + gameid + ": $e");
  }
  return gameDataMap;
}
