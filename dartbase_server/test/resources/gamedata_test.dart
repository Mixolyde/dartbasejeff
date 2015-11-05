library gamedata_test;

import 'dart:convert';
import 'package:redstone/redstone.dart' as red;
import 'package:test/test.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  //load handlers in server library
  setUp((){
    red.redstoneSetUp([#dartbase_server]);
    GameSupervisor.clearGames();
  });

  //remove all loaded handlers
  tearDown(() {
    log("Tearing Down gamedata test server"); 
    red.redstoneTearDown();
  });

  gameDataTests();
}

void gameDataTests() {
  group('get playerdata for game tests', () {
    test('GET playerdata 4 for game 1', () {
      //create a mock request
      var req = new red.MockRequest("/games/1/playerdata/4");
      //dispatch the request
      return red.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameid", 1));
        expect(content, containsPair("playerid", 4));
      });
    });
  });
  group('games list', () {
    test('POST new game empty map', () {
      //create a mock request
      var req = new red.MockRequest("/games",
          method: red.POST, bodyType: red.JSON, body: {});
      //dispatch the request
      return red.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameid", 1));
      });
    });
    test('GET game list', () {
      //create a mock request
      var req = new red.MockRequest("/games");
      //dispatch the request
      return red.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameids", [1]));
      });
    });
  });
  group('gamedata', () {
    test('GET game data', () {
      //create a mock request
      var req = new red.MockRequest("/games/1");
      //dispatch the request
      return red.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameid", 1));
        expect(content, containsPair("playerids", [1, 2, 3, 4]));
      });
    });
  });
}
