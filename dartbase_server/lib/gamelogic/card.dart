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
  static const Card COM = const Card._(CardType.COM, "Communication", 2,-1, true);
  static const Card LAB = const Card._(CardType.LAB, "Laboratory", 3, 1, false);
  static const Card FAC = const Card._(CardType.FAC, "Factory", 4, 1, false);
  static const Card HAB = const Card._(CardType.HAB, "Habitat", 5, 2, false);
  static const Card POW = const Card._(CardType.POW, "Power Station", 6, 3, false);
  static const Card SAB = const Card._(CardType.SAB, "Sabotage", 7, 1, false);
  
  
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

List<Card> newDeck(){
  List<Card> cards = [];
  cards.addAll(List.filled(3, Card.REC));
  cards.addAll(List.filled(2, Card.DOC));
  cards.addAll(List.filled(3, Card.COM));
  cards.addAll(List.filled(4, Card.LAB));
  cards.addAll(List.filled(3, Card.FAC));
  cards.addAll(List.filled(2, Card.HAB));
  cards.addAll(List.filled(1, Card.POW));
  cards.addAll(List.filled(2, Card.SAB));
  return cards;
}

List<Card> shuffleDeck(List<Card> cards) {
  cards.shuffle(getServerRandom());
  return cards;
}

