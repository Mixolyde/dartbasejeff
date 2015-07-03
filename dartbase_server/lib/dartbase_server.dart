// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_server library.
library dartbase_server;

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'package:redstone/server.dart' as app;

//game logic parts
part 'gamelogic/card.dart';
part 'gamelogic/board.dart';
part 'gamelogic/game.dart';
part 'gamelogic/player.dart';
part 'gamelogic/round.dart';

@app.Route("/")
helloWorld() => "Welcome to the dartbase server!";

@app.Route('/serverStatus')
Map getServerStatus() {
  Map statusMap = {};
  try {
    statusMap['running'] = true;
  } catch (e) {
    log("Error getting server status: $e");
  }
  return statusMap;
}

void log(String message) {
  print("(${new DateTime.now().toString()}) $message");
}

Random _random;

Random get serverRandom {
  if (_random == null) {
    var seed = new DateTime.now().millisecondsSinceEpoch;
    _random = new Random(seed);
  }

  return _random;
}

set serverRandom(Random random) => _random = random;
