part of dartbase_server;

enum CardDirection { up, right, down, left }

enum CardType { REC, DOC, COM, LAB, FAC, HAB, POW, SAB }

class Card {
  static const int deckSize = 20;
  static const int handSize = 5;
  final CardType type;
  final String name;
  final int priority;
  final int cost;
  final bool isCap;

  const Card._(this.type, this.name, this.priority, this.cost, this.isCap);

  static const Card rec = const Card._(CardType.REC, "Recreation", 0, -1, true);
  static const Card doc = const Card._(CardType.DOC, "Docking Bay", 1, -1, true);
  static const Card com = const Card._(CardType.COM, "Communication", 2, -1, true);
  static const Card lab = const Card._(CardType.LAB, "Laboratory", 3, 1, false);
  static const Card fac = const Card._(CardType.FAC, "Factory", 4, 1, false);
  static const Card hab = const Card._(CardType.HAB, "Habitat", 5, 2, false);
  static const Card pow = const Card._(CardType.POW, "Power Station", 6, 3, false);
  static const Card sab = const Card._(CardType.SAB, "Sabotage", 7, 1, false);

  String toString() => "Type: ${type.toString()} Name: $name Priority: $priority Cost: $cost isCap: $isCap";
}

class CardUtil {
  static CardDirection opposite(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 2) % 4];
  static CardDirection cw(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 1) % 4];
  static CardDirection ccw(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 3) % 4];
  static Set<CardDirection> exits(CardType type, CardDirection dir) {
    Set<CardDirection> exits = new Set<CardDirection>();

    switch (type) {
      case CardType.REC:
      case CardType.DOC:
      case CardType.COM:
        exits = new Set<CardDirection>.from([dir]);
        break;
      case CardType.LAB:
        exits = new Set<CardDirection>.from([dir, cw(dir)]);
        break;
      case CardType.FAC:
        exits = new Set<CardDirection>.from([dir, opposite(dir)]);
        break;
      case CardType.HAB:
        exits = new Set<CardDirection>.from(CardUtil.allDirections);
        exits.removeWhere((exitdir) => exitdir == dir);
        break;
      case CardType.POW:
        exits = new Set<CardDirection>.from(CardUtil.allDirections);
        break;
      case CardType.SAB:
        throw new ArgumentError.value(CardType.SAB);
        break;
    }

    return exits;
  }

  static const List<CardDirection> allDirections = const [
    CardDirection.down,
    CardDirection.up,
    CardDirection.left,
    CardDirection.right
  ];
}

class DeckUtil {
  static List<Card> _sortedDeck() {
    List<Card> cards = [];
    cards.addAll(new List.filled(3, Card.rec));
    cards.addAll(new List.filled(2, Card.doc));
    cards.addAll(new List.filled(3, Card.com));
    cards.addAll(new List.filled(4, Card.lab));
    cards.addAll(new List.filled(3, Card.fac));
    cards.addAll(new List.filled(2, Card.hab));
    cards.addAll(new List.filled(1, Card.pow));
    cards.addAll(new List.filled(2, Card.sab));
    return cards;
  }

  static List<Card> shuffledDeck() {
    var cards = _sortedDeck();
    cards.shuffle(getServerRandom());
    return cards;
  }
}
