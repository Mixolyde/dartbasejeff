// Copyright (c) 2015, Brian G. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
/// The dartbase_console_client library.
part of dartbase_console_client;

String getInstructions(){
  String inst = "";
  inst += "arrows) Move around board view\n";
  inst += "<, OR >.) Change selection left/right or rotate piece\n";
  inst += "enter) Make selection\n";
  inst += "esc) Cancel selection\n";
  inst += "b) Display board\n";
  inst += "d) Display deferred piles\n";
  inst += "g) Display game data\n";
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
  //TODO handle paging of large card lists
  int count = cards.length;
  if(count == 0) { return "Empty"; }

  String cardEdge = new List.filled(3, '-').join();
  String topAndBottomRow = "   +${new List.filled(count, cardEdge).join('+ +')}+\n";
  String middleRows = "";
  for(int i = 1; i < 4; i++) {
    String innerRow = cards.expand((card) =>
        new List.from([getCardStringRow(card, CardDirection.up, i)])).join('| |');
    middleRows +=  "   |${innerRow}|\n";
  }

  String priorityRow = "P: ";
  priorityRow += cards.expand((card) =>
    new List.from(["${card.priority.toString().padLeft(5)}"])).join(" ");
  priorityRow += "\n";

  String costRow = "C: ";
  costRow += cards.expand((card) =>
    new List.from(["${card.cost.toString().padLeft(5)}"])).join(" ");
  costRow += "\n";

  return topAndBottomRow + middleRows + topAndBottomRow + priorityRow + costRow;
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

String getPlayerData(Game game){
  //TODO return player data
  String playerData = "";
  var roundData = game.round.roundData;
  for (int playerNum in roundData.keys) {
    var player = roundData[playerNum].player;
    playerData += "Player Number: ${playerNum}\n";
    playerData += "Player Name: ${player.name}\n";
    playerData += "Player Cash: ${player.cash}\n";
  }

  return playerData;
}

String getGameData(Game game){
  String gameData = "";
  gameData += "Round: ${game.roundCount}\n";
  gameData += "Game State: ${game.gameState}\n";
  gameData += "Round State: ${game.round.roundState}\n";
  gameData += "Current Round Turn Count: ${game.round.turnCount}\n";
  gameData += "Current Pot: ${game.round.pot}\n";
  gameData += "Player Count: ${game.round.roundData.keys.length}\n";

  return gameData;
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
