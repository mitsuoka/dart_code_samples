// Dart code sample of Future chaining
// Accept button 1, button 2, button 3 and TimeConsumingWork sequentially
// Tested on Dartium
// Source : www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf
// March 2012, by Cresc corp.
// October 2012, incorporated M1 changes
// January 2013, incorporated API and location of dart.js changes
// February 2013, Incorporated API changes

import 'dart:html';
import 'dart:async';

void write(String message) {
  String timestamp = new DateTime.now().toString();
  document.querySelector('#status').insertAdjacentHtml('beforeend', '$timestamp : $message<br>');
}

int timeConsumingWork(int durationInMs){
  var watch = new Stopwatch();
  watch.start();
  while (watch.elapsedMilliseconds < durationInMs){}
  watch.stop();
  return watch.elapsedMilliseconds;
}

class ClickProcessWorker {
  Future<String> run(String buttonID) {
    var completer = new Completer();
    var isComplete = false;
    ButtonElement button = document.querySelector('#$buttonID');
    button.onClick.listen((e){
      if (!isComplete) {
        completer.complete(buttonID);
        isComplete = true;
      }
    });
    write('$buttonID : Returned future');
    return completer.future;
  }
}

class FutureSample_2 {
  void run() {
    try {
      write("FutureSample_2 running");
      Future future = new ClickProcessWorker().run('button1');
      future.then((value){
        write('Accepted "$value" result');
        return new ClickProcessWorker().run('button2');
      })
      .then((value){
        write('Accepted "$value" result');
        return new ClickProcessWorker().run('button3');
      })
      .then((value){
        write('Accepted "$value" result');
        var completer = new Completer();
        timeConsumingWork(1000);
        completer.complete('timeConsumingWork');
        return completer.future;
      })
      .then((value){
         write('Accepted "$value" result');
         write('Done!');
         }
      );
    }
    on Exception catch (e) {
      write('Exception occured');
    }
  }
}

void main() {
  new FutureSample_2().run();
  write('End of "main"');
}