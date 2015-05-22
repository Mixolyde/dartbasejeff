part of dartbase_server;

class Game {

}

class Round {
  final Board board = new Board();
  int turnCount;
  int pot;

  Round() {
    turnCount = 1;
    pot = 0;
  }

  String toString() => "Round $turnCount Board Count: ${board.count} Pot:abstract $pot";
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