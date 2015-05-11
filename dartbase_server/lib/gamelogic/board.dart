part of dartbase_server;

class BoardLoc{
  final int x;
  final int y;
  const BoardLoc(this.x, this.y);

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
}