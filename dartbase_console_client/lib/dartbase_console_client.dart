// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The dartbase_console_client library.
library dartbase_console_client;

import 'package:dartbase_server/gamelogic.dart';

int calculate() {
  return 6 * 7;
}

void printBoard(Board board, BoardLoc centerLoc){
   canvas = new Canvas(120, 50);
   
   if(board.contains(loc)){
     _drawLoc(canvas, board[centerLoc], 60, 25);
   }
   
   print(canvas.frame());
}

void _drawLoc(Canvas canvas, PlayedCard pc, int centerX, int centerY){
  canvas.set(centerX, centerY);
}
