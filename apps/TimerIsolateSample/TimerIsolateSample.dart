/*
 Dart code sample to show how to use the timer isolate library
  note : Following changes will be made in the near future:
   1. Timer will be moved from dart:io to dart:core.
   2. window.{set|clear}{Timeout|Interval} will be deprecated.
   After that, use Timer instad ot window.setInterval such as:
     new Timer.repeating(tickMs, tickFunction);
 Tested on Dartium
 April 2012, by Cresc corp.
 October 2012, incorporated M1 changes
 January 2013, incorporated API changes
 Feburary 2013, API changes (Element.onClick.listen and DateTime) fixed
 March 2013, API changes (Timer and String) fixed
*/

import 'dart:html';
import 'dart:async';
import 'dart:isolate' as isolate;
import 'TimerIsolateLibrary.dart';

// top level variables

// long-lived ports
var receivePort;
var sendPort;

// TimerController object
var timerController;

// spawn and start an isolate
class IsolateStarter {
  void run(Function isolateFunction, Function nextStateFunction) {
    // communication link establishment
    Completer completer = new Completer();
    Future linkEstablished = completer.future;
    var isComplete = false;
    sendPort = isolate.spawnFunction(isolateFunction);
    log('spawned an isolate');
    receivePort = new isolate.ReceivePort();
    sendPort.send('hi', receivePort.toSendPort());  // tell the new send port
    receivePort.receive((msg, replyTo){
      log('initial state message received by parent : $msg');
      if (! isComplete){
        completer.complete(true);
        isComplete = true;
      };
    });
    linkEstablished.then(nextStateFunction);
    log('communication link established');
  }
}

// main class of this application
class TimerController {

  List trips;
  List expiredTrips;
  int elapsedTimeCount = 0;

  var state = IDLE;   // counter mode
  ButtonElement resetButton;
  ButtonElement runButton;
  ButtonElement holdButton;

  void initializeTimer(){
    resetButton = document.query("#b0");
    runButton = document.query("#b1");
    holdButton = document.query("#b2");
    clearButtonColor();
    resetButton.style.backgroundColor = "green";
    trips = [500, 1500, 5000, 2500];  // set trips here
    trips.sort((a,b){return (a - b);});
    expiredTrips = new List<bool>(trips.length);
    for(int i = 0; i < expiredTrips.length; i++) expiredTrips[i] = false;
    writeTrips(trips, expiredTrips, 10);
    sendPort.send({'tripTimes':trips});
  }

  void clearButtonColor(){
    resetButton.style.backgroundColor = "white";
    runButton.style.backgroundColor = "white";
    holdButton.style.backgroundColor = "white";
  }

  // report processor
  processReports(msg, replyTo){
    if (msg is String) {log('received $msg');
    } else if (msg is Map){
      if (msg.containsKey('state')) state = msg['state'];
      if (msg.containsKey('elapsed')) elapsedTimeCount = msg['elapsed'];
      if (msg.containsKey('expiredFlags')) {
        expiredTrips = msg['expiredFlags'];
        writeTrips(trips, expiredTrips, 10);
      }
      if (msg.containsKey('tripTimes')) trips = msg['tripTimes'];
      if (msg.containsKey('expired')) {
        log('received ${msg["expired"]} mS expired message');
      }
    }
  }

  void setupButtonProcess(){
    runButton.onClick.listen((e){
      clearButtonColor();
      runButton.style.backgroundColor = "red";
      log("Run button clicked!");
      sendPort.send('start');
      });
    holdButton.onClick.listen((e){
      clearButtonColor();
      holdButton.style.backgroundColor = "yellow";
      log("Hold button clicked!");
      sendPort.send('hold');
      });
    resetButton.onClick.listen((e){
      clearButtonColor();
      resetButton.style.backgroundColor = "green";
      log("Reset button clicked!");
      sendPort.send('reset');
      });
  }

  void run(value){
    initializeTimer();
    receivePort.receive(processReports);
    setupButtonProcess();

    Duration tick1 = const Duration(milliseconds: 300);  // use 0.3sec tick for display
    new Timer.periodic(tick1, (timer){
      sendPort.send('?elapsed');
      sendPort.send('?expiredFlags');
      writeCounter('Elapsed time : ${formatNumberBy3(elapsedTimeCount)} mS');
      writeTrips(trips, expiredTrips, 10);
    });

    Duration tick2 = const Duration(milliseconds: 20);  // use 20ms tick to the isolate
    new Timer.periodic(tick2, (timer){
      sendPort.send('tick');
    });
  }
}

// top level main function
void main() {
  timerController = new TimerController();
  new IsolateStarter().run(timerIsolate, timerController.run);
}

// functions for formatted output
void log(String msg) {
  String timestamp = new DateTime.now().toString();
  msg = '$timestamp : $msg';
  print(msg);
  document.query('#log').insertAdjacentHtml('beforeend', '$msg<br>');
}

void writeCounter(String message) {
  document.query('#timerCount').innerHtml = message;
}

void writeTrips(List setting, List status, int len) {
  StringBuffer sb = new StringBuffer();
  for (int i = 0; i < setting.length; i++){
    String s = formatNumberBy3(setting[i]);
    String ss = '';
    for(int j = 0; j < len-s.length; j++) ss = '${ss}\u00A0';
    sb.write('$ss$s');
    if (status[i]) sb.write(' : <font color="red">Expired</font>');
    sb.write('<br>');
  }
  document.query('#trips').innerHtml = '$sb';
}

// function to format a number with separators. returns formatted number.
// original JS Author: Robert Hashemian (http://www.hashemian.com/)
// modified for Dart, 2012, by Cresc
// num - the number to be formatted
// decpoint - the decimal point character. if skipped, "." is used
// sep - the separator character. if skipped, "," is used
String formatNumberBy3(num number, {String decpoint: '.', String sep: ','}) {
  // need a string for operations
  String numstr = number.toString();
  // separate the whole number and the fraction if possible
  var a = numstr.split(decpoint);
  var x = a[0]; // decimal
  var y;
  bool nfr = false; // no fraction flag
  if (a.length == 1) { nfr = true;
    } else { y = a[1];
  } // fraction
  var z = "";
  var p = x.length;
  if (p > 3) {
    for (int i = p-1; i >= 0; i--) {
      z = '$z${x[i]}';
      if ((i > 0) && ((p-i) % 3 == 0) && (x[i-1].codeUnitAt(0) >= '0'.codeUnitAt(0))
          && (x[i-1].codeUnitAt(0) <= '9'.codeUnitAt(0))) { z = '$z,';
      }
    }
    // reverse z to get back the number
    x = '';
    for (int i = z.length - 1; i>=0; i--) x = '$x${z[i]}';
  }
    // add the fraction back in, if it was there
    if (nfr) return x; else return '$x$decpoint$y';
}