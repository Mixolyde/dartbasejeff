// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:dartbase_console_client/dartbase_console_client.dart';

import 'dart:io';
import 'package:args/args.dart';

const PLAYERS = 'players';

ArgResults argResults;

main(List<String> arguments) {
  final parser = new ArgParser()
      ..addFlag(PLAYERS, negatable: false, abbr: 'p');

  argResults = parser.parse(arguments);
  List<String> rest = argResults.rest;

  //dcat(paths, argResults[LINE_NUMBER]);
  print('Received rest: $rest');

  LocalConsoleClient client = new LocalConsoleClient(2);
}
