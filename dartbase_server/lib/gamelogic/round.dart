part of gamelogic;

enum RoundState { make_selections, play_card, round_over, game_over }

class Round {
  final Board board = new Board();
  RoundState roundState = RoundState.make_selections;
  final Map<int, PlayerRoundData> roundData = {};
  Map<Card, List<Player>> selections = {};
  int turnCount;
  int pot;

  Round(List<Player> players) {
    for (var player in players) {
      roundData[player.playerNum] = new PlayerRoundData(player);
    }
    turnCount = 1;
    pot = 0;
  }

  void resetRound() {
    board.resetBoard();
    for (int playerNum in roundData.keys) {
      var player = roundData[playerNum].player;
      roundData[playerNum] = new PlayerRoundData(player);
    }
    roundState = RoundState.make_selections;
    selections = {};
    turnCount = 1;
    pot = 0;
  }

  void makeSelection(Player player, Card card) {
    //TODO allow a player to change selection before all selections are in
    if(roundState != RoundState.make_selections) return;

    if (roundData[player.playerNum].hand.contains(card) && getSelection(player) == null) {
      if (selections.containsKey(card)) {
        selections[card].add(player);
      } else {
        //new list
        selections[card] = [player];
      }
    }

    log("Selection list for ${card.shortName} has ${selections[card].length} players");

    var playerCount = selections.keys.fold(0, (prev, card) => prev + selections[card].length);

    if (playerCount == roundData.keys.length) {
      //all selections are in
      _handleSelections();
    }
  }

  Card getSelection(Player player) {
    for (Card card in selections.keys) {
      if (selections[card].contains(player)) return card;
    }
    return null;
  }

  bool playCard(Player player, Card card, BoardLoc loc, CardDirection playedDir,
      [PaymentPath path]) {
    //validity checks
    if(roundState != RoundState.play_card) {
      return false;
    }

    if (activePlayer != player) {
      return false;
    }

    if (!roundData[player.playerNum].deferred.contains(card)) {
      return false;
    }

    if (!board.isLegalMove(loc, card, playedDir)) {
      return false;
    }

    //if the player has at least one card in the board, and not one
    //immediately connected neighbor card of the same player exists, a path is required
    bool pathRequired = board.countByPlayer(player.playerNum) > 0 &&
      !CardDirection.values.any((dir) =>
        CardUtil.exits(card,playedDir).contains(dir) &&
        board.boardMap[loc.neighborLoc(dir)] != null &&
        board.boardMap[loc.neighborLoc(dir)].playerNum == player.playerNum &&
        board.boardMap[loc.neighborLoc(dir)].exits.contains(CardUtil.opposite(dir)));

    //validate path if required
    if (pathRequired && (path == null ||
      !board.validPaymentPath(loc, card, playedDir, player.playerNum, path))){
      return false;
    }

    board.playCardToStation(loc, card, playedDir, player.playerNum);

    roundData[player.playerNum].deferred.remove(card);

    //update pot and player cash for card payment
    _payConstructionFee(card, player);
    if(player.cash == 0){
      _endGame();

      return true;
    }

    if(pathRequired) {
      _payConnectionFees(new PaymentPath.from(path), player);

      if(player.cash == 0){
        _endGame();

        return true;
      }
    }

    if (board.isClosed) {
      _endRound(player);

      return true;
    }

    if (roundData[player.playerNum].deferred.length == 0) {
      //remove player from play list
      selections.keys
          .where((card) => selections[card].contains(player))
          .toList()
          .forEach(selections.remove);
    }

    _checkAnyPlayable();

    //update round state if no players left to move
    if (selections.keys.length == 0) {
      roundState = RoundState.make_selections;
      turnCount += 1;
    }

    return true;
  }

  void _endRound(Player player) {
    //handle payment for unbuilt cards
    for (int playerNum in roundData.keys) {
      var player = roundData[playerNum].player;
      int cashPaid = min(player.cash, roundData[playerNum].deferred.length);
      print("Player ${playerNum} has to pay ${cashPaid} to pot for unbuilt cards.");
      player.cash -= cashPaid;
      pot += cashPaid;
    }

    //winner receives pot
    player.cash += pot;

    pot = 0;

    roundState = RoundState.round_over;

    selections = {};
  }

  void _endGame(){
    roundState = RoundState.game_over;
    selections = {};
  }

  void _handleSelections() {
    log("Handling selections: $selections");
    //discard selection and replenish hand
    for (Card card in selections.keys) {
      for (Player player in selections[card]) {
        var playerNum = player.playerNum;
        roundData[playerNum].hand.remove(card);
        roundData[playerNum].hand.add(roundData[playerNum].deck.removeAt(0));
      }
    }

    //add selected card to deferred list for playing later
    for (Card card in selections.keys) {
      for (Player player in selections[card]) {
        roundData[player.playerNum].deferred.add(card);
      }
    }

    //determine deferred cards
    _checkDeferred();

    //set round state so playable check can get active player
    roundState = RoundState.play_card;

    _checkAnyPlayable();

    //update round state and wait for card placement
    if (selections.keys.length == 0) {
      //end of turn, back to making selections
      roundState = RoundState.make_selections;
      turnCount += 1;
      log("End of turn, Round Data: ${this.toString()}");
    }
  }

  void _payConstructionFee(Card card, Player player) {
    if (card.isCap && pot > 0) {
      print("Card is cap, and pot has cash.");
      pot -= 1;
      player.cash += 1;
      return;
    }
    if (!card.isCap) {
      int cashPaid = min(player.cash, card.cost);
      print("Card is not cap, updating cash by ${cashPaid}.");
      player.cash -= cashPaid;
      pot += cashPaid;
      return;
    }
  }

  void _payConnectionFees(PaymentPath path, Player player) {
    if(path.length == 0 ||
      board.boardMap[path.first].playerNum == player.playerNum ||
      player.cash == 0) return;

    BoardLoc first = path.removeAt(0);
    int payment = 1;
    player.cash -= payment;
    //get player that owns the card in the payment path
    log("Adding $payment to Player: ${roundData[board.boardMap[first].playerNum]} cash");
    roundData[board.boardMap[first].playerNum].player.cash += payment;

    //recurse on rest of path
    _payConnectionFees(path, player);
  }

  void _checkDeferred() {
    //remove players that were deferred this round
    selections.keys
        .where((card) => selections[card].length > 1)
        .toList()
        .forEach(selections.remove);
  }

  void _checkAnyPlayable() {
    print("Checking if any playable for activePlayer: ${activePlayer}");
    print("Round Data: ${roundData}");
    if (activePlayer == null) return;
    if (!roundData[activePlayer.playerNum].deferred.any((card) => board.isPlayable(card))) {
      //active player has no playable cards, remove from selection list
      selections.keys
          .where((card) => selections[card].contains(activePlayer))
          .toList()
          .forEach(selections.remove);
      if (selections.keys.length > 0) {
        //check next player
        _checkAnyPlayable();
      }
    }
  }

  Player get activePlayer {
    if (roundState == RoundState.make_selections || selections.keys.length == 0) {
      return null;
    } else {
      var sortedCards = selections.keys.toList();
      sortedCards.sort((a, b) => b.priority.compareTo(a.priority));

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
  PlayerRoundData(this.player) {
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
