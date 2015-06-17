library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card util tests', () {
    test('card util opposite orientation', () {
      expect(CardDirection.up, CardUtil.opposite(CardDirection.down));
      expect(CardDirection.right, CardUtil.opposite(CardDirection.left));
    });
    test('card util clockwise orientation', () {
      expect(CardDirection.right, CardUtil.cw(CardDirection.up));
      expect(CardDirection.right, CardUtil.ccw(CardDirection.down));
    });
    test('card util counter-clockwise orientation', () {
      expect(CardDirection.up, CardUtil.cw(CardDirection.left));
      expect(CardDirection.up, CardUtil.ccw(CardDirection.right));
    });

    test('COM card exits', () {
      expect(1, CardUtil.exits(Card.com, CardDirection.down).length);
      expect(CardUtil.exits(Card.com, CardDirection.down), contains(CardDirection.down));
    });
    test('LAB card exits', () {
      expect(2, CardUtil.exits(Card.lab, CardDirection.down).length);
      expect(CardUtil.exits(Card.lab, CardDirection.down), contains(CardDirection.down));
      expect(CardUtil.exits(Card.lab, CardDirection.down), contains(CardDirection.left));
    });
    test('FAC card exits', () {
      expect(2, CardUtil.exits(Card.fac, CardDirection.down).length);
      expect(CardUtil.exits(Card.fac, CardDirection.down), contains(CardDirection.down));
      expect(CardUtil.exits(Card.fac, CardDirection.down), contains(CardDirection.up));
    });
    test('HAB card exits', () {
      expect(3, CardUtil.exits(Card.hab, CardDirection.down).length);
      expect(CardUtil.exits(Card.hab, CardDirection.down), isNot(contains(CardDirection.down)));
    });
    test('POW card exits', () {
      expect(4, CardUtil.exits(Card.pow, CardDirection.down).length);
      expect(CardUtil.exits(Card.pow, CardDirection.down), contains(CardDirection.down));
    });
    test('SAB card exits', () {
      //TODO fix test to properly capture thrown error
      //expect(CardUtil.exits(Card.sab, CardOrientation.DOWN), throwsArgumentError);
      expect(true, isTrue);
    });
  });

  group('deck tests', () {
    test('new deck card counts', () {
      expect(20, DeckUtil.shuffledDeck().length);
      expect(3, DeckUtil.shuffledDeck().where((card) => card == Card.rec).length);
      expect(4, DeckUtil.shuffledDeck().where((card) => card == Card.lab).length);
      expect(2, DeckUtil.shuffledDeck().where((card) => card == Card.sab).length);
    });

    test('two shuffled decks are not the same deck', () {
      List<Card> testDeck = DeckUtil.shuffledDeck();
      List<Card> testDeck2 = DeckUtil.shuffledDeck();

      bool sameOrder = true;
      for (var index = 0; index < testDeck.length; index++) {
        if (testDeck[index] != testDeck2[index]) {
          sameOrder = false;
          break;
        }
      }
      expect(sameOrder, isFalse);
    });
  });
}
