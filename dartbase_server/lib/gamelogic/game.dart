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
  RoundState roundState = RoundState.make_selections;
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
    if(roundData[player].hand.contains(card) && getSelection(player) == null){
      if(selections.containsKey(card)){
        selections[card].add(player);
      } else {
        //new list
        selections[card] = [player];
      }
    }

    print("Selection list for $card has ${selections[card].length} players");

    var playerCount = selections.keys.fold(0, (prev, card) => prev + selections[card].length);

    if(playerCount == roundData.keys.length){
      //all selections are in
      handleSelections();
    }
  }

  Card getSelection(Player player){
    for(Card card in selections.keys){
      if(selections[card].contains(player)) return card;
    }
    return null;
  }

  void handleSelections(){
    print("Handling $selections");
    //discard selection and replenish hand
    for(Card card in selections.keys){
      for(Player player in selections[card]){
        roundData[player].hand.remove(card);
        roundData[player].hand.add(
            roundData[player].deck.removeAt(0));
      }
    }

    //add selected card to deferred list for playing later
    for(Card card in selections.keys){
      for (Player player in selections[card]){
        roundData[player].deferred.add(card);
      }
    }

    //determine deferred cards
    checkDeferred();

    //update round state and wait for card placement
    if(selections.keys.length > 0){
      roundState = RoundState.play_card;
    } else {
      //end of turn
      turnCount += 1;
    }
  }

  void checkDeferred(){
    //remove players that were deferred this round
    selections.keys
      .where((card) => selections[card].length > 1)
      .toList()
      .forEach(selections.remove);
  }

  Player get activePlayer {
    if (roundState == RoundState.make_selections){
      return null;
    } else {
      return null;
    }

  }

  String toString() => "Round $turnCount State: $roundState Board Count: ${board.count} Pot: $pot";
}

class PlayerRoundData {
  final Player player;
  final List<Card> hand = [];
  final List<Card> deferred = [];
  final List<Card> deck = [];
  PlayerRoundData(this.player){
    var shuffledDeck = DeckUtil.shuffledDeck();
    hand.addAll(shuffledDeck.take(5));
    hand.sort((a, b) => a.priority.compareTo(b.priority));
    deck.addAll(shuffledDeck.skip(5));
  }

  String toString() => "Round Data for: ${player.toString}\n\t" +
      "Hand: $hand\n\tDeferred:abstract $deferred\n\tDeck:abstract $deck";
}
