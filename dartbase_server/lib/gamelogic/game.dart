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
      for(int playerNum in round.roundData.keys){
        log("Starting hand Player ${playerNum}: ${CardUtil.cardsToString(round.roundData[playerNum].hand)}");
      };
      gameState = GameState.started;
      return true;
    }
  }

}

class Round {
  final Board board = new Board();
  RoundState roundState = RoundState.make_selections;
  final Map<int, PlayerRoundData> roundData = {};
  Map<Card, List<Player>> selections = {};
  int turnCount;
  int pot;

  Round(List<Player> players) {
    for(var player in players){
      roundData[player.playerNum] = new PlayerRoundData(player);
    }
    turnCount = 1;
    pot = 0;
  }

  void makeSelection(Player player, Card card){
    //TODO allow a player to change selection before all selections are in
    if(roundData[player.playerNum].hand.contains(card) && getSelection(player) == null){
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
    if (!roundData[player.playerNum].deferred.contains(card)){
      return false;
    }

    if(!board.isLegalMove(loc, card, playedDir)){
      return false;
    }

    board.playCardToStation(loc, card, playedDir, player.playerNum);

    roundData[player.playerNum].deferred.remove(card);

    //TODO update pot and player cash for card payment
    _handlePayment(card, player);
    //TODO handle connection fees
    //TODO handle end of game if player runs out of cash
    //TODO check for end of round
    //TODO handle end of round
    //TODO update turn state

    if(roundData[player.playerNum].deferred.length == 0){
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
    log("Handling selections: $selections");
    //discard selection and replenish hand
    for(Card card in selections.keys){
      for(Player player in selections[card]){
        var playerNum = player.playerNum;
        roundData[playerNum].hand.remove(card);
        roundData[playerNum].hand.add(
            roundData[playerNum].deck.removeAt(0));
      }
    }

    //add selected card to deferred list for playing later
    for(Card card in selections.keys){
      for (Player player in selections[card]){
        roundData[player.playerNum].deferred.add(card);
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
    print ("Round data 1 players: ${roundData.keys}");
    print ("Round data 1 values: ${roundData.values}");
    print ("Round data 1 for $player: ${roundData[player]}");

    if(card.isCap && pot > 0){
      print("Card is cap, and pot has cash.");
      pot -= 1;
      player.cash += 1;
      return;
    }
    if(!card.isCap){
      int cashPaid = min(player.cash, card.cost);
      print("Card is not cap, updating cash by ${cashPaid}.");
      player.cash -= cashPaid;
      pot += cashPaid;
      return;
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
    if(! roundData[activePlayer.playerNum].deferred.any((card) => board.isPlayable(card))){
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
    hand.addAll(shuffledDeck.take(5).toList());
    hand.sort((a, b) => a.priority.compareTo(b.priority));
    deck.addAll(shuffledDeck.skip(5).toList());
  }

  String toString() => "Round Data for: ${player.toString()}\n" +
      "\tHand:     ${CardUtil.cardsToString(hand)}\n" +
      "\tDeferred: ${CardUtil.cardsToString(deferred)}\n" +
      "\tDeck:     ${CardUtil.cardsToString(deck)}";
}
