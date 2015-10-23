library gamedata_test;

import 'dart:convert';
import 'package:redstone/redstone.dart' as app;
import 'package:test/test.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  //load handlers in server library
  setUp(() => app.setUp([#dartbase_server]));

  //remove all loaded handlers
  tearDown(() => app.tearDown());

  gameDataTests();
}

void gameDataTests() {
  group('get playerdata for game tests', () {
    test('GET playerdata 4 for game 1', () {
      //create a mock request
      var req = new MockRequest("/game/1/playerdata/4");
      //dispatch the request
      return app.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameid", 1));
        expect(content, containsPair("playerid", 1));
      });
    });
    test('GET game list', () {
      //create a mock request
      var req = new MockRequest("/game");
      //dispatch the request
      return app.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameids", [1]));
      });
    });
  });
}
