library dartbase_server_test;

import 'dart:convert';
import 'package:redstone/mocks.dart';
import 'package:redstone/server.dart' as app;
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
      var req = new MockRequest("/game/1/playerData/4");
      //dispatch the request
      return app.dispatch(req).then((resp) {
        //verify the response
        expect(resp.statusCode, equals(200));
        var content = JSON.decode(resp.mockContent);
        expect(content, containsPair("gameid", 1));
        expect(content, containsPair("playerid", 1));
      });
    });
  });

}
