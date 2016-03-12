// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library print_cards.test;

import 'package:dartbase_console_client/dartbase_console_client.dart';
import 'package:test/test.dart';

import 'package:dartbase_server/gamelogic.dart';

void main() {
  group('card prints', () {
    test('print empty list', () {
      expect(getCardList(new List<Card>.from([])), "Empty");
    });
    test('print card list without highlight', () {
      String hand = getCardList(new List<Card>.from([Card.rec, Card.lab, Card.fac, Card.hab, Card.pow, Card.sab]));
      print(hand);
      expect(hand.contains("| O | | O-| | O | |-O-| |-O-| |-*-|"), true);
      expect(hand.contains("Rec   Lab   Fac   Hab   Pow   Sab"), true);
      expect(hand.contains("   0     3     4     5     6     7"), true);
      expect(hand.contains("  -1     1     1     2     3     1"), true);

    });
    test('print card list with highlight at the beginning', () {
      String hand = getCardList(
        new List<Card>.from([Card.rec, Card.lab, Card.fac, Card.hab, Card.pow, Card.sab]),
      highlight: 0);
      print(hand);
      expect(hand.contains("+***+ +---+ +---+ +---+ +---+ +---+"), true);
      expect(hand.contains("* O * | O-| | O | |-O-| |-O-| |-*-|"), true);
      expect(hand.contains("Rec   Lab   Fac   Hab   Pow   Sab"), true);
      expect(hand.contains("   0     3     4     5     6     7"), true);
      expect(hand.contains("  -1     1     1     2     3     1"), true);

    });
    test('print card list with highlight at the end', () {
      String hand = getCardList(
        new List<Card>.from([Card.rec, Card.lab, Card.fac, Card.hab, Card.pow, Card.sab]),
      highlight: 5);
      print(hand);
      expect(hand.contains("+---+ +---+ +---+ +---+ +---+ +***+"), true);
      expect(hand.contains("| O | | O-| | O | |-O-| |-O-| *-*-*"), true);
      expect(hand.contains("Rec   Lab   Fac   Hab   Pow   Sab"), true);
      expect(hand.contains("   0     3     4     5     6     7"), true);
      expect(hand.contains("  -1     1     1     2     3     1"), true);

    });
    test('print card list with highlight in the middle', () {
      String hand = getCardList(
        new List<Card>.from([Card.rec, Card.lab, Card.fac, Card.hab, Card.pow, Card.sab]),
      highlight: 2);
      print(hand);
      expect(hand.contains("+---+ +---+ +***+ +---+ +---+ +---+"), true);
      expect(hand.contains("| O | | O-| * O * |-O-| |-O-| |-*-|"), true);
      expect(hand.contains("Rec   Lab   Fac   Hab   Pow   Sab"), true);
      expect(hand.contains("   0     3     4     5     6     7"), true);
      expect(hand.contains("  -1     1     1     2     3     1"), true);

    });
  });

}
