// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
/// The dartbase_console_client library.
part of dartbase_console_client;

String printBoard(Board board, BoardLoc viewLoc, int cardWidth, int cardHeight){
  //TODO verify input valid inputs
  if (board.count == 0) { return "Empty Board"; }
  
  

}

String printCardList(List<Card> cards){
  int count = cards.length;
  if(count == 0) => "Empty";
  
  String cardEdge = new List.filled(3, ' ').join();
  String topAndBottomRow = "+${new List.filled(count, horizontalEdge).join('+')}+\n";
  String cardTopRow = "|${new List.filled(count, 'AAA').join('|')}|\n";
  String cardMiddleRow = "|${new List.filled(count, 'AAA').join('|')}|\n";
  String cardBottomRow = "|${new List.filled(count, 'AAA').join('|')}|\n";

  return topAndBottomRow + cardTopRow + cardMiddleRow + cardBottomRow + topAndBottomRow;
}
