// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dartbase_server_test;

import 'dart:convert';
import 'package:redstone/redstone.dart' as red;
import 'package:test/test.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('gamesupervisor tests', () {
    test('gamesupervisor new games', () {
      expect(GameSupervisor.newGame({}), 1);
      expect(GameSupervisor.newGame({}), 2);
    });
  });
}
