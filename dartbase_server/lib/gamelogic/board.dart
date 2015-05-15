part of dartbase_server;

class Board {
  Map<BoardLoc, PlayedCard> boardMap;
  Set<BoardLoc> fringe;

  Board() {
    boardMap = new Map<BoardLoc, PlayedCard>();
    fringe = new Set<BoardLoc>.from([BoardLoc.origin]);

  }

  bool isClosed() => fringe.length == 0;

}

class BoardLoc{
  final int x;
  final int y;
  const BoardLoc(this.x, this.y);
  BoardLoc.from(BoardLoc loc): x = loc.x, y = loc.y;

  static final BoardLoc origin =
      const BoardLoc(0, 0);

  String toString() => "{$x, $y}";

  BoardLoc neighborLoc(CardOrientation dir) {
    switch (dir) {
      case CardOrientation.up:
        return new BoardLoc(this.x, this.y + 1);
      case CardOrientation.down:
        return new BoardLoc(this.x, this.y - 1);
      case CardOrientation.left:
        return new BoardLoc(this.x - 1, this.y);
      case CardOrientation.right:
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
  final CardOrientation dir;
  final int playerNum;
  const PlayedCard(this.card, this.dir, this.playerNum);

  Set<CardOrientation> exits() => CardUtil.exits(card.type, dir);

  String toString() => "Played: {${card.toString()}, ${dir.toString()}, $playerNum}";

}
