part of dartbase_server;

enum GameState { not_started, started, ended }

class Game {
  Round round;
  int roundCount = 1;
  List<Player> players = [];
  GameState gameState = GameState.not_started;
  Game();

  bool get isStarted => gameState != GameState.not_started;

  bool addPlayer(String name) {
    if (isStarted) return false;
    if (players.length == 4) return false;

    players.add(new Player(players.length + 1, name));
    return true;
  }

  bool startGame() {
    if (isStarted) {
      return true;
    } else {
      //return false if not enough players
      if (players.length <= 1) return false;

      //initialize round data
      round = new Round(players);
      //print out new game details
      log("Starting game with ${players.length} players. Initial hands:");
      for (int playerNum in round.roundData.keys) {
        log("Starting hand Player ${playerNum}: ${CardUtil.cardsToString(round.roundData[playerNum].hand)}");
      };

      gameState = GameState.started;
      return true;
    }
  }

  void makeSelection(Player player, Card card) {
    round.makeSelection(player, card);
  }

  bool playCard(Player player, Card card, BoardLoc loc, CardDirection playedDir,
      [PaymentPath path]) {
    //play card in round
    var result = round.playCard(player, card, loc, playedDir, path);
    //TODO detect end of game
    //TODO detect end of round and wait for new round

    return result;
  }
}

