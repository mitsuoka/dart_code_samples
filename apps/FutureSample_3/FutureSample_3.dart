// Dart code sample to explain Future.wait method
// Wait for button 1, button 2, button 3 and TimeConsumingWork to complete
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
  document.query('#status').insertAdjacentHtml('beforeend', '$timestamp : $message<br>');
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
    ButtonElement button = document.query('#$buttonID');
    button.onClick.listen((e){
      if (!isComplete) {
        write('$buttonID clicked');
        isComplete = true;
        completer.complete(buttonID);
      }
    });
    write('$buttonID : Returned future');
  return completer.future;
  }
}

class FutureSample_3 {
  void run() {
    List<Future> futures = [
      new ClickProcessWorker().run('button1'),
      new ClickProcessWorker().run('button2'),
      new ClickProcessWorker().run('button3'),
      heavyWork()
    ];
    Future.wait(futures).then((values){
      write('Accept values : $values');
      write('Done!');
    });
    futures.forEach((future){
      future.catchError((exception) => write('Exception occured'));
    });
  }

  Future heavyWork(){
    var completer = new Completer();
    timeConsumingWork(1000);
    completer.complete('timeConsumingWork');
    write('timeConsumingWork : Returned future');
    return completer.future;
  }
}

void main() {
  new FutureSample_3().run();
  write('End of "main"');
}