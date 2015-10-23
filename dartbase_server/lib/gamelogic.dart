// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The gamelogic library.
library gamelogic;

import 'package:collection/collection.dart';

import 'dart:math';

//game logic parts
part 'gamelogic/card.dart';
part 'gamelogic/board.dart';
part 'gamelogic/game.dart';
part 'gamelogic/player.dart';
part 'gamelogic/round.dart';

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
