import 'dart:html';

class ButtonTest {

  ButtonTest() {
  }

  void run() {
    write("Button test");
    ButtonElement button = document.querySelector("#button");
    button.onClick.listen((e) => write("Clicked!"));
  }

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.querySelector('#status').innerHtml = message;
  }
}

void main() {
  new ButtonTest().run();
}