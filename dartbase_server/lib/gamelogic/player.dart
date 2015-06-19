part of dartbase_server;

class Player {
  final String name;
  final int playerNum;
  int cash;
  Player(this.playerNum, this.name){
    cash = 50;
  }

  String toString() => "Player #$playerNum: $name with $cash credits";

  int get hashCode {
    int result = 17;
    result = 37 * result + playerNum;
    result = 37 * result + name.hashCode;
    result = 37 * result + cash;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  bool operator ==(other) {
    if (other is! Player) return false;
    Player player = other;
    print "Comparing $this to $player";
    return (player.playerNum == playerNum &&
        player.name == name &&
        player.cash == cash);
  }

}
