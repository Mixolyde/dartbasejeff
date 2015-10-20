// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
part of dartbase_server;

import 'package:redstone/server.dart' as app;


@app.Route("/game/:gameid/playerdata/:playerid")
Map getPlayerDataForGame(int gameid, int playerid) {
  Map gameDataMap = {};
  try {
    gameDataMap['gameid'] = gameid;
    gameDataMap['playerid'] = playerid;
  } catch (e) {
    log("Error getting PlayerData For Game " + gameid + ": $e");
  }
  return gameDataMap;
}
