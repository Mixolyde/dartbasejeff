part of dartbase_server;

enum GameState { not_started, started, ended }
enum RoundState { make_selections, play_card, choose_paypath }

class Game {
  Round round;
  List<Player> players = [];
  GameState gameState = GameState.not_started;
  Game();

  bool get isStarted => gameState != GameState.not_started;

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
      gameState = GameState.started;
      return true;
    }
  }

}

class Round {
  final Board board = new Board();
  RoundState state = RoundState.make_selections;
  final Map<Player, PlayerRoundData> roundData = {};
  Map<Card, List<Player>> selections = {};
  int turnCount;
  int pot;

  Round(List<Player> players) {
    for(var player in players){
      roundData[player] = new PlayerRoundData(player);
    }
    turnCount = 1;
    pot = 0;
  }

  void makeSelection(Player player, Card card){
    //TODO allow a player to change selection before all selections are in
    //TODO check that card is in the player's hand
    if(getSelection(player) == null){
      if(selections.containsKey(card)){
        selections[card].add(player);
      } else {
        //new list
        selections[card] = [player];
      }
    }

    if(selections.keys.length == roundData.keys.length){
      //all selections are in
      determineTurnOrder();
    }
  }

  Card getSelection(Player player){
    for(Card card in selections.keys){
      if(selections[card].contains(player)) return card;
    }
    return null;
  }

  void determineTurnOrder(){
    //discard selection and replenish hand
    for(Card card in selections.keys){
      for(Player player in selections[card]){
        roundData[player].hand.remove(card);
        roundData[player].hand.add(
            roundData[player].deck.removeAt(0));
      }
    }

    //determine deferred cards
    checkDeferred();

    //determine turn order

    //update round state and wait for card placement
  }

  checkDeferred(){

  }

  String toString() => "Round $turnCount State: $state Board Count: ${board.count} Pot: $pot";
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
