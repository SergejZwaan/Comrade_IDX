class Button {
  boolean hover, clicked;
  int x, y, w, h;
  String text;
  int buttonCol;

  Button( int inputx, int inputy, int inputw, int inputh, String inputtext ) {
    x = inputx;
    y = inputy;
    w = inputw;
    h = inputh;
    text = inputtext;
    hover = false;
    clicked = false;
    buttonCol = 255;
  }

  void display() {
    if (hover) {
      buttonCol = 200;
    } else {
      buttonCol = 255;
    }
    fill(buttonCol);
    rect(x, y, w, h);
    fill(0);
    text(text, x+10, y+20);
  }

  boolean checkHover() {
    if (mouseX < (x+w) && mouseX > x) {
      if (mouseY < (y+w) && mouseY > y) {
        hover = true;
      } else {
        hover = false;
      }
    } else {
      hover = false;
    }
    return hover;
  }


  boolean checkClicked() {
    if (mousePressed) {
      clicked = true;
    } else {
      clicked = false;
    }
    return clicked;
  }
}