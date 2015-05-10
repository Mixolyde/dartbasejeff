library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card tests', () {
    test('card orientation util', () {
      expect(CardOrientation.UP, CardUtil.opposite(CardOrientation.DOWN));
      expect(CardOrientation.RIGHT, CardUtil.opposite(CardOrientation.LEFT));
      expect(CardOrientation.RIGHT, CardUtil.cw(CardOrientation.UP));
      expect(CardOrientation.RIGHT, CardUtil.ccw(CardOrientation.DOWN));
      expect(CardOrientation.UP, CardUtil.cw(CardOrientation.LEFT));
      expect(CardOrientation.UP, CardUtil.ccw(CardOrientation.RIGHT));
    });

    test('card exits', () {
      expect(1, CardUtil.exits(CardType.COM, CardOrientation.DOWN).length);
      expect(CardUtil.exits(CardType.COM, CardOrientation.DOWN), contains(CardOrientation.DOWN));

      expect(2, CardUtil.exits(CardType.LAB, CardOrientation.DOWN).length);
      expect(CardUtil.exits(CardType.LAB, CardOrientation.DOWN), contains(CardOrientation.DOWN));
      expect(CardUtil.exits(CardType.LAB, CardOrientation.DOWN), contains(CardOrientation.LEFT));

      expect(2, CardUtil.exits(CardType.FAC, CardOrientation.DOWN).length);
      expect(CardUtil.exits(CardType.FAC, CardOrientation.DOWN), contains(CardOrientation.DOWN));
      expect(CardUtil.exits(CardType.FAC, CardOrientation.DOWN), contains(CardOrientation.UP));

      expect(3, CardUtil.exits(CardType.HAB, CardOrientation.DOWN).length);
      expect(CardUtil.exits(CardType.HAB, CardOrientation.DOWN), isNot(contains(CardOrientation.DOWN)));

      expect(4, CardUtil.exits(CardType.POW, CardOrientation.DOWN).length);
      expect(CardUtil.exits(CardType.POW, CardOrientation.DOWN), contains(CardOrientation.DOWN));

      //TODO fix test to properly capture thrown error
      //expect(CardUtil.exits(CardType.SAB, CardOrientation.DOWN), throwsArgumentError);
    });
  });

  group('deck tests', () {
    test('new deck', () {
      expect(20, DeckUtil.shuffledDeck().length);
      expect(3, DeckUtil.shuffledDeck().where((card) => card.type == CardType.REC).length);
      expect(4, DeckUtil.shuffledDeck().where((card) => card.type == CardType.LAB).length);
      expect(2, DeckUtil.shuffledDeck().where((card) => card.type == CardType.SAB).length);
    });

    test('same deck', () {
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
