library card_test;

import 'package:unittest/unittest.dart';

import 'package:dartbase_server/dartbase_server.dart';

void main() {
  group('card tests', () {
    test('card orientation util', () {
      expect(CardOrientation.up, CardUtil.opposite(CardOrientation.down));
      expect(CardOrientation.right, CardUtil.opposite(CardOrientation.left));
      expect(CardOrientation.right, CardUtil.cw(CardOrientation.up));
      expect(CardOrientation.right, CardUtil.ccw(CardOrientation.down));
      expect(CardOrientation.up, CardUtil.cw(CardOrientation.left));
      expect(CardOrientation.up, CardUtil.ccw(CardOrientation.right));
    });

    test('card exits', () {
      expect(1, CardUtil.exits(CardType.COM, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.COM, CardOrientation.down), contains(CardOrientation.down));

      expect(2, CardUtil.exits(CardType.LAB, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.LAB, CardOrientation.down), contains(CardOrientation.down));
      expect(CardUtil.exits(CardType.LAB, CardOrientation.down), contains(CardOrientation.left));

      expect(2, CardUtil.exits(CardType.FAC, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.FAC, CardOrientation.down), contains(CardOrientation.down));
      expect(CardUtil.exits(CardType.FAC, CardOrientation.down), contains(CardOrientation.up));

      expect(3, CardUtil.exits(CardType.HAB, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.HAB, CardOrientation.down), isNot(contains(CardOrientation.down)));

      expect(4, CardUtil.exits(CardType.POW, CardOrientation.down).length);
      expect(CardUtil.exits(CardType.POW, CardOrientation.down), contains(CardOrientation.down));

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
