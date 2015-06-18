part of dartbase_server;

enum GameState { not_started, started, ended }
enum RoundState { make_selections, play_card, choose_paypath }

class Game {
  Round round;
  int roundCount = 1;
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
      //print out new game details
      log("Starting game with ${players.length} players. Initial hands:");
      for(Player player in round.roundData.keys){
        var cardNamesInHand = round.roundData[player].hand.map((card) => card.shortName);
        log("Starting hand for ${player.name}: ${cardNamesInHand.join(", ")}");
      };
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

    log("Selection list for ${card.shortName} has ${selections[card].length} players");

    var playerCount = selections.keys.fold(0, (prev, card) => prev + selections[card].length);

    if(playerCount == roundData.keys.length){
      //all selections are in
      _handleSelections();
    }
  }

  Card getSelection(Player player){
    for(Card card in selections.keys){
      if(selections[card].contains(player)) return card;
    }
    return null;
  }

  bool playCard(Player player, Card card, BoardLoc loc, CardDirection playedDir){
    //validity checks
    if (activePlayer != player){
      return false;
    }
    if (!roundData[player].deferred.contains(card)){
      return false;
    }

    if(!board.isLegalMove(loc, card, playedDir)){
      return false;
    }

    board.playCardToStation(loc, card, playedDir, player.playerNum);

    roundData[player].deferred.remove(card);

    print ("Round data players: ${roundData.keys}");
    print ("Round data for $player: ${roundData[player]}");

    //TODO update pot and player cash for card payment
    _handlePayment(card, player);
    //TODO handle connection fees
    //TODO handle end of game if player runs out of cash
    //TODO check for end of round
    //TODO handle end of round
    //TODO update turn state
    print ("Round data players: ${roundData.keys}");
    print ("Round data for $player: ${roundData[player]}");

    if(roundData[player].deferred.length == 0){
      //remove player from play list
      selections.keys
            .where((card) => selections[card].contains(player))
            .toList()
            .forEach(selections.remove);
    }

    _checkAllPlayable();

    //update round state if no players left to move
    if(selections.keys.length == 0){
      roundState = RoundState.make_selections;
      turnCount += 1;
    }

    return true;

  }

  void _handleSelections(){
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
    _checkDeferred();

    _checkAllPlayable();

    //update round state and wait for card placement
    if(selections.keys.length > 0){
      roundState = RoundState.play_card;
    } else {
      //end of turn
      turnCount += 1;
      log("End of turn, Round: ${this.toString()}");
    }
  }

  void _handlePayment(Card card, Player player){
    if(card.isCap && pot > 0){
      pot -= 1;
      player.cash += 1;
      return;
    }
    if(!card.isCap){
      int cashPaid = min(player.cash, card.cost);
      player.cash -= cashPaid;
      pot += cashPaid;
    }

  }

  void _checkDeferred(){
    //remove players that were deferred this round
    selections.keys
      .where((card) => selections[card].length > 1)
      .toList()
      .forEach(selections.remove);
  }
  void _checkAllPlayable(){
    if(activePlayer == null) return;
    if(! roundData[activePlayer].deferred.any((card) => board.isPlayable(card))){
      //active player has no playable cards, remove from selection list
      selections.keys
           .where((card) => selections[card].contains(activePlayer))
           .toList()
           .forEach(selections.remove);
      if(selections.keys.length > 0){
        //check next player
        _checkAllPlayable();
      }
    }

  }

  Player get activePlayer {
    if (roundState == RoundState.make_selections || selections.keys.length == 0){
      return null;
    } else {
      var sortedCards = selections.keys.toList();
      sortedCards.sort( (a, b) => b.priority.compareTo(a.priority));

      //return only player for first card in descending priority order
      return selections[sortedCards[0]][0];
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

  String toString() => "Round Data for: ${player.toString()}\n\t" +
      "Hand: $hand\n\tDeferred:abstract $deferred\n\tDeck:abstract $deck";
}
