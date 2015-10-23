// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dartbase_server_test;

import 'dart:convert';
import 'package:redstone/redstone.dart' as web;
import 'package:test/test.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  //load handlers in server library
  setUp(() => web.redstoneSetUp([#dartbase_server]));

  //remove all loaded handlers
  tearDown(() => web.redstoneTearDown());

  serverTests();
}

void serverTests() {
  group('server tests', () {
    test('GET server status', () {
      //create a mock request
      var req = new MockRequest("/serverStatus");
      //dispatch the request
      return web.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("running", true));
      });
    });
    test('GET index', () {
      //create a mock request
      var req = new MockRequest("/");
      //dispatch the request
      return web.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = resp.mockContent;
        expect(content, equals("Welcome to the dartbase server!"));
      });
    });
  });

  group('utility tests', () {
    test('get server static random', () {
      //create a mock request
      var rand1 = serverRandom;
      var rand2 = serverRandom;
      expect(rand1, isNotNull);
      expect(rand2, isNotNull);
      expect(rand1.nextInt(100000), isNot(equals(rand2.nextInt(100000))));
    });
    test('log doesn\'t fail', () {
      //create a mock request
      log("unit test log message");
    });
  });
}
