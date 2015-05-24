part of dartbase_server;

class Game {
  Round round;
  bool _isStarted = false;
  List<Player> players = [];
  Game();

  bool get isStarted => _isStarted;

  bool addPlayer(String name) {
    if(isStarted) return false;
    if(players.length == 4) return false;

    players.add(new Player(players.length + 1, name));
    return true;
  }

  bool startGame(){
    if (isStarted){
      return true;
    } else {
      //return false if not enough players
      if(players.length <= 1) return false;

      //initialize round data
      round = new Round(players);
      _isStarted = true;
      return true;
    }
  }

}

class Round {
  final Board board = new Board();
  final Map<Player, PlayerRoundData> roundData = {};
  Map<Player, Card> selections = {};
  int turnCount;
  int pot;

  Round(List<Player> players) {
    for(var player in players){
      roundData[player] = new PlayerRoundData(player);
    }
    turnCount = 1;
    pot = 0;
  }

  String toString() => "Round $turnCount Board Count: ${board.count} Pot: $pot";
}

class PlayerRoundData {
  final Player player;
  final List<Card> hand = [];
  final List<Card> deferred = [];
  final List<Card> deck = [];
  PlayerRoundData(this.player){
    var shuffledDeck = DeckUtil.shuffledDeck();
    hand.addAll(shuffledDeck.take(5));
    deck.addAll(shuffledDeck.skip(5));
  }

  String toString() => "Round Data for: ${player.toString}\n\t" +
      "Hand: $hand\n\tDeferred:abstract $deferred\n\tDeck:abstract $deck";
}
