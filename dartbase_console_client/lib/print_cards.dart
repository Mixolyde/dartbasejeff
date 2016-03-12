// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
/// The dartbase_console_client library.
part of dartbase_console_client;

String getCardList(List<Card> cards, {int highlight: -1}){
  //TODO highlight numbered card with stars
  //TODO handle paging of large card lists
  int count = cards.length;
  if(count == 0) { return "Empty"; }

  String cardEdge = new List.filled(3, '-').join();
  String highlightEdge = new List.filled(3, '*').join();
  String topAndBottomRow = "   ";
  if(highlight <0 || highlight >= count){
    //no highlight
    topAndBottomRow += "+${new List.filled(count, cardEdge).join('+ +')}+\n";
  } else {
    if(highlight > 0){
      topAndBottomRow += "+${new List.filled(highlight, cardEdge).join('+ +')}+ ";
    }
    topAndBottomRow += "+${highlightEdge}+";
    if(highlight < count - 1){
      topAndBottomRow += " +${new List.filled((count - 1) - highlight, cardEdge).join('+ +')}+\n";
    } else {
      topAndBottomRow += "\n";
    }
  }
  String middleRows = "";
  for(int i = 1; i <= 3; i++) {  //for each row
    var cardStrings = [];
    for(int j = 0; j < count; j++){  //for each card, need the index for highlight check
      String cardRow =  getCardStringRow(cards[j], CardDirection.up, i);
      if(j == highlight){
        cardStrings.add("*" + cardRow + "*");
      } else {
        cardStrings.add("|" + cardRow + "|");
      }
    }
    middleRows += "   " + cardStrings.join(' ') + "\n";
  }

  String nameRow = "N: ";
  nameRow += cards.expand((card) =>
    new List.from(["${card.name.substring(0, 3).padLeft(4)}"])).join("  ");
  nameRow += "\n";

  String priorityRow = "P: ";
  priorityRow += cards.expand((card) =>
    new List.from(["${card.priority.toString().padLeft(5)}"])).join(" ");
  priorityRow += "\n";

  String costRow = "C: ";
  costRow += cards.expand((card) =>
    new List.from(["${card.cost.toString().padLeft(5)}"])).join(" ");
  costRow += "\n";

  return topAndBottomRow + middleRows + topAndBottomRow
  + nameRow + priorityRow + costRow;
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
