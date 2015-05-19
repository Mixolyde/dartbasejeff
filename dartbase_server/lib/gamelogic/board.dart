part of dartbase_server;

class Board {
  Map<BoardLoc, PlayedCard> boardMap;
  Set<BoardLoc> fringe;

  Board() {
    boardMap = new Map<BoardLoc, PlayedCard>();
    fringe = new Set<BoardLoc>.from([BoardLoc.origin]);

  }

  bool playCardToStation(BoardLoc loc, Card card, CardDirection dir, int playerNum){
    if (count == 0){
      //force the location to 0,0 if the board is empty
      loc = BoardLoc.origin;
    }

    if (isLegalMove(loc, card, dir)){
      var pc = new PlayedCard(card, dir, playerNum);
      boardMap[loc] = pc;
      updateFringe(loc, pc);
      return true;
    } else {
      return false;
    }
  }

  void updateFringe(BoardLoc loc, PlayedCard pc){
    for(CardDirection exit in CardUtil.exits(pc.card.type, pc.dir)){
      print("Updating fringe in direction: $exit");
      BoardLoc neighbor = loc.neighborLoc(exit);
      if(!boardMap.keys.contains(neighbor)){
        fringe.add(neighbor);
      }
    }
    print("Removing played card location from fringe: $loc");
    fringe.remove(loc);
  }

  bool isLegalMove(BoardLoc loc, Card card, CardDirection dir){
    if(card.type == CardType.SAB) return false;

    if(boardMap.keys.length == 0) return true;

    if(!fringe.contains(loc)) return false;

    //TODO check for legal exit matching
    return true;

  }

  bool playSabotage(BoardLoc loc){
    if(isLegalSabotage(loc)){
      boardMap.remove(loc);
      fringe.add(loc);
      return true;
    } else {
      return false;
    }
  }

  bool isLegalSabotage(BoardLoc loc){
    //TODO check location for station separation
    return boardMap.containsKey(loc);
  }

  bool get isClosed => fringe.length == 0;

  int get count => boardMap.length;

}

class BoardLoc{
  final int x;
  final int y;
  const BoardLoc(this.x, this.y);
  BoardLoc.from(BoardLoc loc): x = loc.x, y = loc.y;

  static final BoardLoc origin =
      const BoardLoc(0, 0);

  String toString() => "{$x, $y}";

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
    return (boardLoc.x == x &&
        boardLoc.y == y);
  }
}

class PlayedCard {
  final Card card;
  final CardDirection dir;
  final int playerNum;
  const PlayedCard(this.card, this.dir, this.playerNum);

  Set<CardDirection> exits() => CardUtil.exits(card.type, dir);

  String toString() => "Played: {${card.toString()}, ${dir.toString()}, $playerNum}";

}
