// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
/// The dartbase_console_client library.
part of dartbase_console_client;

String getInstructions(){
  String inst = "";
  inst += "arrows) Move around board view\n";
  inst += ",.) Change selection left/right\n";
  inst += "b) Display board\n";
  inst += "d) Display deferred piles\n";
  inst += "h) Display hand\n";
  inst += "p) Display player data\n";
  inst += "q) Quit\n";
  inst += "?) Display instructions\n";

  return inst;
}
String getBoard(Board board, BoardLoc viewLoc, int cardWidth, int cardHeight){
  //TODO verify input valid inputs
  //TODO highlight selected card or path with stars
  if (board.count == 0) { return "Empty Board"; }

  return "";

}

String getCardList(List<Card> cards, {int highlight: -1}){
  //TODO highlight numbered card with stars
  int count = cards.length;
  if(count == 0) { return "Empty"; }

  String cardEdge = new List.filled(3, '-').join();
  String topAndBottomRow = "+${new List.filled(count, cardEdge).join('+ +')}+\n";
  String middleRows = "";
  for(int i = 1; i < 4; i++) {
    String innerRow = cards.expand((card) =>
        new List.from([getCardStringRow(card, CardDirection.up, i)])).join('| |');
    middleRows +=  "|${innerRow}|\n";
  }

  //TODO print card stats below cards

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
          result = " " + _exitChar(card, dir, CardDirection.up) + " ";
          break;
        case 2:
          result = _exitChar(card, dir, CardDirection.left) + "O" + _exitChar(card, dir, CardDirection.right);
          break;
        case 3:
          result = " " + _exitChar(card, dir, CardDirection.down) + " ";
          break;
      }
      break;

  }
  return result;
}

String _exitChar(Card card, CardDirection dir, CardDirection exit){
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
