import 'dart:html';
import 'dart:async';
final int timerValue = 5000; // set timeout here in ms

void main() {
  query("#start_text_id").text = "Click the prompt";
  query("#prompt_text_id").text = "Click me within ${timerValue~/1000} seconds!";
  doRepeat();
}

class ClickProcessWorker {
  Future run() {
    var completer = new Completer();
    var text = document.query("#prompt_text_id");
    text.onClick.listen((e){
      if (!completer.isCompleted) {
        completer.complete('clicked');
      }
    });
  return completer.future;
  }
}

doRepeat() {
  Future future = new ClickProcessWorker().run();
  timeout(future, timerValue, "prompting click")
  .then( (result) {
    reverseText();
    doRepeat();
    },
    onError: (err){
    query("#prompt_text_id").text = "Timeout expired!";
 });
}

Future timeout(Future input, int milliseconds, String description) {
  var completer = new Completer();
  var timer = new Timer(new Duration(milliseconds: milliseconds), () {
    completer.completeError(new TimeoutException(
        'Timed out while $description.'));
  });
  input.then((value) {
    if (completer.isCompleted) return;
    timer.cancel();
    completer.complete(value);
  }).catchError((e) {
    if (completer.isCompleted) return;
    timer.cancel();
    completer.completeError(e);
  });
  return completer.future;
}

class TimeoutException implements Exception{
    const TimeoutException([String this.message = ""]);
    String toString() => "TimeoutException: $message";
    final String message;
}

void reverseText() {
  var text = query("#prompt_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  query("#prompt_text_id").text = buffer.toString();
}
