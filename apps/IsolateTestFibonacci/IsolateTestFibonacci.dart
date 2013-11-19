/*
 * Dart code sample for concurrency tests.
 * Tested on Dartium.
 * Place dart.js bootstrup code in the packages/browser holder
 * July 2012, by Cresc corp.
 * October 2012, incorporated M1 changes.
 * January 2013, incorporated API changes.
 * February 2013, incorporated API change (Date -> DateTime).
 * November 2013, incorporated Isolate API breaking changes
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:html'; // enable this to run on  Dartium or Dert2JS

// isolate status
final CONNECTING = 1;
final CONNECTED = 2;
final STOPPED = 3;


// parent isolate class
class ParentIsolate {
  // status
  var status = CONNECTING;
  // long-lived ports
  var receivePort = new ReceivePort();
  SendPort sendPort;

  // establish communication link
  linkEstablish(msg){
    if (msg is SendPort) {
      sendPort = msg;
      sendPort.send('ping');
    }
    else if (msg == 'pong') {
      log('main received : $msg');
      log('link established');
      status = CONNECTED;
      run();
    }
  }

  // link established, then do things here
  run([msg = null]) {
    if (msg == null) { // active transmission
      log('parent started Fibonacci computing');
      var stopwatch = new Stopwatch()..start();
      int i = 40;
      int y = fib(i);
      stopwatch.stop;
      log('parent finished Fib(${i}) = ${y} in ${stopwatch.elapsedMilliseconds}mS');
      sendPort.send('quit');  // send 'quit' to close the child's receive port
    }
    else log('main received : $msg');  // response transmission
  }

  // main process
  void main() {
    // communication link establishment
    Isolate.spawnUri(Uri.parse('IsolateTestFibonacci_child.dart'),
                                     ['_'], receivePort.sendPort)
      .then((iso){
        log('spawned workerIsolate #${iso.hashCode}');
      });  // receive messages and dispatch them
    receivePort.listen((msg){
      if (status == CONNECTING) linkEstablish(msg);
      else if (status == CONNECTED) run(msg);
    });
  }
}


main() {
  new ParentIsolate().main();
}


void log(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $msg');
  //enable next line to run on Dartium or Dart2JS
  document.body.nodes.add(new Element.html('<div>$timestamp : $msg</div>'));
}


// Fibonacci function
int fib(int i) {
  if (i < 2) return i;
  return fib(i - 2) + fib(i - 1);
}
