import 'dart:html';
import 'dart:math';

class CanvasTest {

  CanvasTest() {
  }

  int width, height;
  CanvasRenderingContext2D ctx;

  void run() {
    write("Canvas test");
    CanvasElement ce = document.querySelector("#canvas");
    ctx = ce.getContext("2d");
    width = ce.width; height = ce.height;
    ctx.strokeRect(0, 0, width, height);
    ce.onMouseDown.listen(onMouseDown);
  }

  void write(String message) {
    document.querySelector('#status').innerHtml = message;
  }

  void onMouseDown(event) {
    int x = event.offset.x;
    int y = event.offset.y;
    int r = 30;
    ctx.moveTo(x + r, y);
    ctx.arc(x, y, r, 0, PI * 2, false);
    ctx.fillStyle = 'blue';
    ctx.fill();
  }
}

void main() {
  new CanvasTest().run();
}