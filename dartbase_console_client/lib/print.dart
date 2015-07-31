// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
/// The dartbase_console_client library.
part of dartbase_console_client;

import 'package:console/console.dart';

final Map <int, Color> player_colors = {
  1 : Color.RED,
  2 : Color.GREEN,
  3 : Color.GOLD,
  4 : Color.DARK_BLUE
};

final Map <int, Color> player_bright_colors = {
  1 : Color.DARK_RED,
  2 : Color.LIME,
  3 : Color.YELLOW,
  4 : Color.BLUE
};

String printBoard(Board board, BoardLoc viewLoc, int cardWidth, int cardHeight){
  //TODO verify input valid inputs
  if (board.count == 0) { return "Empty Board"; }



}

String printCardList(List<Card> cards){
  int count = cards.length;
  if(count == 0) { return "Empty"; }

  String cardEdge = new List.filled(3, '-').join();
  String topAndBottomRow = "+${new List.filled(count, cardEdge).join('++')}+\n";
  String middleRows = "";
  for(int i = 1; i < 4; i++) {
    String innerRow = cards.expand((card) =>
        new List.from([getCardStringRow(card, CardDirection.up, i)])).join('||');
    middleRows +=  "|${innerRow}|\n";
  }

  return topAndBottomRow + middleRows + topAndBottomRow;
}

String getCardStringRow(Card card, CardDirection dir, int row){
  String result;
  switch (card) {
    case Card.sab:
      switch (row) {
        case 1:
          result = "\\|/";
          break;
        case 2:
          result = "-*-";
          break;
        case 3:
          result = "/|\\";
          break;
      }
      break;
    case Card.pow:
      switch (row) {
        case 1:
        case 3:
          result = " | ";
          break;
        case 2:
          result = "-O-";
          break;
      }
      break;
    default:
      switch (row) {
        case 1:
          result = " " + exitChar(card, dir, CardDirection.up) + " ";
          break;
        case 2:
          result = exitChar(card, dir, CardDirection.left) + "O" + exitChar(card, dir, CardDirection.right);
          break;
        case 3:
          result = " " + exitChar(card, dir, CardDirection.down) + " ";
          break;
      }
      break;

  }
  return result;
}

String exitChar(Card card, CardDirection dir, CardDirection exit){
  if (CardUtil.exits(card, dir).contains(exit)){
    switch (exit){
      case CardDirection.up:
      case CardDirection.down:
          return "|";
      case CardDirection.left:
      case CardDirection.right:
          return "-";
    }
  }
  return " ";
}
