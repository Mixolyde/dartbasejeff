part of dartbase_server;

enum CardOrientation {
  UP,
  RIGHT,
  DOWN,
  LEFT
}

class CardOrientationUtil {
  static CardOrientation opposite(CardOrientation orientation) => 
      CardOrientation.values[(orientation.index + 2) % 4];
  static CardOrientation cw(CardOrientation orientation) => 
        CardOrientation.values[(orientation.index + 1) % 4];
  static CardOrientation ccw(CardOrientation orientation) => 
        CardOrientation.values[(orientation.index + 3) % 4];
}

