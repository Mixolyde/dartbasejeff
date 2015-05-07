part of dartbase_server;

enum CardOrientation {
  UP,
  RIGHT,
  DOWN,
  LEFT
}

enum CardType {
  REC,
  DOC,
  COM,
  LAB,
  FAC,
  HAB,
  POW,
  SAB
}

class Card {
  final CardType type;
  final String name;
  final int priority;
  final int cost;
  final bool isCap;
  
  const Card._(this.type, this.name, this.priority, this.cost, this.isCap);
  
  static const Card REC = const Card._(CardType.REC, "Recreation", 0, -1, true);
  static const Card DOC = const Card._(CardType.DOC, "Docking Bay", 1, -1, true);
  
  
  String toString() => "Type: ${type.toString()} Name: $name Priority: $priority Cost: $cost isCap: $isCap";
  
}

class CardUtil {
  static CardOrientation opposite(CardOrientation orientation) => 
      CardOrientation.values[(orientation.index + 2) % 4];
  static CardOrientation cw(CardOrientation orientation) => 
        CardOrientation.values[(orientation.index + 1) % 4];
  static CardOrientation ccw(CardOrientation orientation) => 
        CardOrientation.values[(orientation.index + 3) % 4];
}

