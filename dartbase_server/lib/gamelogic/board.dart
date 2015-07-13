part of dartbase_server;

class Board {
  Map<BoardLoc, PlayedCard> boardMap;
  Set<BoardLoc> fringe;

  Board() {
    resetBoard();
  }
  // deep copy board
  Board.from(Board board){
    fringe = board.fringe.toSet();
    boardMap = new Map<BoardLoc, PlayedCard>();
    board.boardMap.keys.forEach((loc) {
      PlayedCard pc = board.boardMap[loc];
      boardMap[loc] = new PlayedCard(pc.card, pc.dir, pc.playerNum);
    });
  }

  void resetBoard() {
    boardMap = new Map<BoardLoc, PlayedCard>();
    fringe = new Set<BoardLoc>.from([BoardLoc.origin]);
  }

  bool contains(BoardLoc loc) {
    return boardMap.containsKey(loc);
  }

  List<BoardLoc> connectedNeighbors(BoardLoc loc) {
    if (!contains(loc)) return new List<BoardLoc>();

    return CardUtil.allDirections.expand((dir) {
      var playedHasExit = boardMap[loc].exits.contains(dir);
      var neighborHasExit = contains(loc.neighborLoc(dir)) &&
          boardMap[loc.neighborLoc(dir)].exits
          .contains(CardUtil.opposite(dir));
      if(playedHasExit && neighborHasExit){
        return [loc.neighborLoc(dir)];
      } else {
        return [];
      }
    }).toList();
  }
  
  bool areConnected(BoardLoc loc1, BoardLoc loc2){
    return contains(loc1) && connectedNeighbors(loc1).contains(loc2);
  }

  bool playCardToStation(BoardLoc loc, Card card, CardDirection dir, int playerNum) {
    if (count == 0) {
      //force the location to 0,0 if the board is empty
      loc = BoardLoc.origin;
    }

    if (isLegalMove(loc, card, dir)) {
      if (card == Card.sab) {
        _playSabotage(loc);
        return true;
      } else {
        var pc = new PlayedCard(card, dir, playerNum);
        boardMap[loc] = pc;
        updateFringe(loc, pc);
        return true;
      }
    } else {
      return false;
    }
  }

  void updateFringe(BoardLoc loc, PlayedCard pc) {
    for (CardDirection exit in CardUtil.exits(pc.card, pc.dir)) {
      BoardLoc neighbor = loc.neighborLoc(exit);
      if (!contains(neighbor)) {
        fringe.add(neighbor);
      }
    }
    log("Removing played card location from fringe: $loc");
    fringe.remove(loc);
  }

  bool isLegalMove(BoardLoc loc, Card card, CardDirection playedDir) {
    if (card == Card.sab) return _isLegalSabotage(loc);

    if (count == 0) return true;

    if (!fringe.contains(loc)) return false;

    //Test each side of the played card to see if it fits
    return CardUtil.allDirections.every((CardDirection dir) {
      BoardLoc neighborLoc = loc.neighborLoc(dir);
      if (!contains(neighborLoc)) {
        //empty board location is a valid exit
        return true;
      } else {
        var playedHasExit = CardUtil.exits(card, playedDir).contains(dir);
        var neighborHasExit = boardMap[neighborLoc].exits
            .contains(CardUtil.opposite(dir));

        //return true if both have the exit, or neither have it
        return playedHasExit == neighborHasExit;
      }
    });
  }

  bool _playSabotage(BoardLoc loc) {
    if (_isLegalSabotage(loc)) {
      log("Removing ${boardMap[loc]} with sabotage");
      boardMap.remove(loc);
      fringe.add(loc);
      // for each neighbor of the blown up location
      for (CardDirection dir in CardUtil.allDirections) {
        var neighborLoc = loc.neighborLoc(dir);
        if (fringe.contains(neighborLoc)) {
          //check all of this locations neighbors for an exit facing it
          if (!CardUtil.allDirections.any((exitDir) => contains(neighborLoc.neighborLoc(exitDir)) &&
              boardMap[neighborLoc.neighborLoc(exitDir)].exits
                  .contains(CardUtil.opposite(exitDir)))) {
            fringe.remove(neighborLoc);
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  bool _isLegalSabotage(BoardLoc loc) {
    //playing sab with an empty board is legal anywhere
    if (count == 0) return true;

    if (!contains(loc)) return false;

    if (count < 3) return true;

    // check location for station separation
    Board sabotagedBoard = new Board.from(this);
    sabotagedBoard.boardMap.remove(loc);
    return Board.isConnected(sabotagedBoard);
  }

  static bool isConnected(Board board){
    var connectedLocs = allConnectedLocs(board, board.boardMap.keys.first);

    return board.count == connectedLocs.length;

  }

  static Set<BoardLoc> allConnectedLocs(Board board, BoardLoc start){
    //Dykstra's algorithm
    Set<BoardLoc> fringe = board.connectedNeighbors(start).toSet();

    Set<BoardLoc> seen = _dykstraConnections(board, new Set<BoardLoc>.from([start]), fringe);

    return seen;
  }

  static Set<BoardLoc> _dykstraConnections(Board board, Set<BoardLoc> seen, Set<BoardLoc> fringe){
    //if fringe is empty, return
    if(fringe.length == 0) return seen;
    var first = fringe.first;
    fringe.remove(first);
    seen.add(first);
    List<BoardLoc> neighbors = board.connectedNeighbors(first);
    neighbors.forEach((neighbor) {if(!seen.contains(neighbor)) fringe.add(neighbor);});
    return _dykstraConnections(board, seen, fringe);

  }


  List<PaymentPath> payPaths(BoardLoc from, BoardLoc to) {
    //assumes card has been played to board
    //TODO determine possible payment paths
    //int payingPlayer = boardMap[from].playerNum;

    return [new PaymentPath([from, to], {1: 1})];
  }

  bool isPlayable(Card card) {
    //sabotages are always playable somewhere
    if (card == Card.sab) {
      return true;
    }

    //test every direction of every location in fringe
    for (BoardLoc loc in fringe) {
      for (CardDirection playedDir in CardUtil.allDirections) {
        if (isLegalMove(loc, card, playedDir)) return true;
      }
    }
    //exhausted fringe
    return false;
  }

  bool get isClosed => fringe.length == 0;

  int get count => boardMap.length;
}

class PaymentPath {
  // List of boardlocations in path (inclusive).
  final List<BoardLoc> pathLocs;
  // Map of payments costs to other players
  final Map<int, int> playerPayments;
  PaymentPath(this.pathLocs, this.playerPayments);
}

class BoardLoc {
  final int x;
  final int y;
  const BoardLoc(this.x, this.y);
  BoardLoc.from(BoardLoc loc)
      : x = loc.x,
        y = loc.y;

  static final BoardLoc origin = const BoardLoc(0, 0);

  BoardLoc neighborLoc(CardDirection dir) {
    switch (dir) {
      case CardDirection.up:
        return new BoardLoc(this.x, this.y + 1);
      case CardDirection.down:
        return new BoardLoc(this.x, this.y - 1);
      case CardDirection.left:
        return new BoardLoc(this.x - 1, this.y);
      case CardDirection.right:
        return new BoardLoc(this.x + 1, this.y);
    }
  }

  String toString() => "{$x, $y}";

  int get hashCode {
    int result = 17;
    result = 37 * result + x;
    result = 37 * result + y;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  bool operator ==(other) {
    if (other is! BoardLoc) return false;
    BoardLoc boardLoc = other;
    return (boardLoc.x == x && boardLoc.y == y);
  }
}

class PlayedCard {
  final Card card;
  final CardDirection dir;
  final int playerNum;
  const PlayedCard(this.card, this.dir, this.playerNum);

  Set<CardDirection> get exits => CardUtil.exits(card, dir);

  String toString() => "Played: {${card.toString()}, ${dir.toString()}, $playerNum}";
}
