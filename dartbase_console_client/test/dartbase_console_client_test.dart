// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dartbase_console_client.test;

import 'package:dartbase_console_client/dartbase_console_client.dart';
import 'package:unittest/unittest.dart';

import 'package:dartbase_server/gamelogic.dart';

void main() {
  test('Start local client', () {
    LocalConsoleClient client = new LocalConsoleClient(2);
    expect(client.state, GameState.started);
  });

}
