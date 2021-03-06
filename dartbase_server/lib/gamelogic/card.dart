part of gamelogic;

enum CardDirection { up, right, down, left }

class Card {
  static const int deckSize = 20;
  static const int handSize = 5;
  final String name;
  final int priority;
  final int cost;
  final bool isCap;

  const Card._(this.name, this.priority, this.cost, this.isCap);

  static const Card rec = const Card._("Recreation", 0, -1, true);
  static const Card doc = const Card._("Docking Bay", 1, -1, true);
  static const Card com = const Card._("Communication", 2, -1, true);
  static const Card lab = const Card._("Laboratory", 3, 1, false);
  static const Card fac = const Card._("Factory", 4, 1, false);
  static const Card hab = const Card._("Habitat", 5, 2, false);
  static const Card pow = const Card._("Power Station", 6, 3, false);
  static const Card sab = const Card._("Sabotage", 7, 1, false);

  static const List<Card> values = const [
    Card.rec,
    Card.doc,
    Card.com,
    Card.lab,
    Card.fac,
    Card.hab,
    Card.pow,
    Card.sab
  ];

  String toString() => "Type: $shortName " +
      "Name: $name Priority: $priority Cost: $cost isCap: $isCap";

  String get shortName => name.substring(0, 3).toLowerCase();
}

class CardUtil {
  static CardDirection opposite(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 2) % 4];
  static CardDirection cw(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 1) % 4];
  static CardDirection ccw(CardDirection orientation) =>
      CardDirection.values[(orientation.index + 3) % 4];
  static Set<CardDirection> exits(Card card, CardDirection dir) {
    Set<CardDirection> exits = new Set<CardDirection>();

    switch (card) {
      case Card.rec:
      case Card.doc:
      case Card.com:
        exits = new Set<CardDirection>.from([dir]);
        break;
      case Card.lab:
        exits = new Set<CardDirection>.from([dir, cw(dir)]);
        break;
      case Card.fac:
        exits = new Set<CardDirection>.from([dir, opposite(dir)]);
        break;
      case Card.hab:
        exits = new Set<CardDirection>.from(CardDirection.values);
        exits.removeWhere((exitdir) => exitdir == dir);
        break;
      case Card.pow:
        exits = new Set<CardDirection>.from(CardDirection.values);
        break;
      case Card.sab:
        throw new ArgumentError.value(Card.sab);
        break;
    }

    return exits;
  }

  static String cardsToString(List<Card> cards) {
    var shortNames = cards.map((card) => card.shortName).join(",");
    return "[${shortNames}]";
  }
}

class DeckUtil {
  static const Map<Card, int> cardCounts = const {
    Card.rec: 3,
    Card.doc: 2,
    Card.com: 3,
    Card.lab: 4,
    Card.fac: 3,
    Card.hab: 2,
    Card.pow: 1,
    Card.sab: 2
  };

  static List<Card> _sortedDeck() {
    return Card.values
        .expand((card) => new List.filled(DeckUtil.cardCounts[card], card))
        .toList();
  }

  static List<Card> shuffledDeck() {
    var cards = _sortedDeck();
    cards.shuffle(serverRandom);
    return cards;
  }
}
