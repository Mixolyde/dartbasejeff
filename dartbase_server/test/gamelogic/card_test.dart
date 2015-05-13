library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card util tests', () {
    test('card util opposite orientation', () {
      expect(CardOrientation.up, CardUtil.opposite(CardOrientation.down));
      expect(CardOrientation.right, CardUtil.opposite(CardOrientation.left));
    });
    test('card util clockwise orientation', () {
      expect(CardOrientation.right, CardUtil.cw(CardOrientation.up));
      expect(CardOrientation.right, CardUtil.ccw(CardOrientation.down));
    });
    test('card util counter-clockwise orientation', () {
      expect(CardOrientation.up, CardUtil.cw(CardOrientation.left));
      expect(CardOrientation.up, CardUtil.ccw(CardOrientation.right));
    });

    test('COM card exits', () {
      expect(1, CardUtil.exits(CardType.COM, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.COM, CardOrientation.down), contains(CardOrientation.down));
    });
    test('LAB card exits', () {
      expect(2, CardUtil.exits(CardType.LAB, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.LAB, CardOrientation.down), contains(CardOrientation.down));
      expect(CardUtil.exits(CardType.LAB, CardOrientation.down), contains(CardOrientation.left));
    });
    test('FAC card exits', () {
      expect(2, CardUtil.exits(CardType.FAC, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.FAC, CardOrientation.down), contains(CardOrientation.down));
      expect(CardUtil.exits(CardType.FAC, CardOrientation.down), contains(CardOrientation.up));
    });
    test('HAB card exits', () {
      expect(3, CardUtil.exits(CardType.HAB, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.HAB, CardOrientation.down), isNot(contains(CardOrientation.down)));
    });
    test('POW card exits', () {
      expect(4, CardUtil.exits(CardType.POW, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.POW, CardOrientation.down), contains(CardOrientation.down));
    });
    test('SAB card exits', () {
      //TODO fix test to properly capture thrown error
      //expect(CardUtil.exits(CardType.SAB, CardOrientation.DOWN), throwsArgumentError);
      expect(true, isTrue);
    });
  });

  group('deck tests', () {
    test('new deck card counts', () {
      expect(20, DeckUtil.shuffledDeck().length);
      expect(3, DeckUtil.shuffledDeck().where((card) => card.type == CardType.REC).length);
      expect(4, DeckUtil.shuffledDeck().where((card) => card.type == CardType.LAB).length);
      expect(2, DeckUtil.shuffledDeck().where((card) => card.type == CardType.SAB).length);
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
