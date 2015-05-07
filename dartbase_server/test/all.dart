// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library all_tests;

import 'dartbase_server_test.dart' as dartbase_server_test;
import 'gamelogic/board_test.dart' as board_test;
import 'gamelogic/card_test.dart' as card_test;
import 'gamelogic/game_test.dart' as game_test;
import 'gamelogic/player_test.dart' as player_test;

void main() {
  dartbase_server_test.main();
  board_test.main();
  card_test.main();
  game_test.main();
  player_test.main();
  
}
