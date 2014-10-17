import 'dart:html';

class ButtonTest {

  ButtonTest() {
  }

  void run() {
    write("Button test");
    ButtonElement button = document.query("#button");
    button.onClick.listen((e) => write("Clicked!"));
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.query('#status').innerHtml = message;
  }
}

void main() {
  new ButtonTest().run();
}