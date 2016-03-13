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

String getPlayerData(Game game){
  //TODO return count of cards left in draw pile
  String playerData = "";
  var roundData = game.round.roundData;
  for (int playerNum in roundData.keys) {
    var player = roundData[playerNum].player;
    playerData += "Player Number: ${playerNum}\n";
    playerData += "Player Name: ${player.name}\n";
    playerData += "Player Cash: ${player.cash}\n";
    playerData += "Draw Pile left: ${roundData[playerNum].deck.length}\n";
    if(roundData[playerNum].deferred.length > 0){
      playerData += "Deferred Cards: " + roundData[playerNum].deferred.expand((card) =>
        new List.from(["${card.name.substring(0, 3).padLeft(3)}"])).join(" ") + "\n";
    } else {
      playerData += "${player.name} has no Deferred Cards.\n";
    }
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
