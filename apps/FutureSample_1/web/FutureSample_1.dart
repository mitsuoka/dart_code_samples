// Dart code sample descripting basic use of Future / Completer interfaces
// Tested on Dartium
// Source : www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf
// March 2012, by Cresc corp.
// January 2013, Incorporated API and location of dart.js changes
// February 2013, Incorporated API changes

import 'dart:html';
import 'dart:async';

void write(String message) {
  String timestamp = new DateTime.now().toString();
  document.querySelector('#status').insertAdjacentHtml('beforeend', '<br>$timestamp : $message');
}

class ClickProcessWorker {
  Future run() {
    var completer = new Completer();
    var isComplete = false;
    ButtonElement button = document.querySelector("#button");
    button.onClick.listen((e){
      if (!isComplete) {
        completer.complete('button');
        isComplete = true;
      }
    });
    write('Returned future');
  return completer.future;
  }
}

class FutureSample_1 {
  void run() {
    write("FutureSample_1.run() started");
    Future future = new ClickProcessWorker().run();
    future.then( (result) => write('Accepted $result result'));
    // do things here
    write("FutureSample_1.run() exited");
  }
}

void main() {
  new FutureSample_1().run();
}