/*
 * Dart code sample for concurrency tests.
 * Evaluate performances in the following cases:
 *  1) Only the parent computes fib() Fibonacci function (comment out lines 40 and 41)
 *  2) Parent uses fib() and the child uses fibo() function (comment out line 41)
 *  2) Parent and child share the same fib() function (comment out line 40)
 * Tested on Dartium.
 * Place dart.js bootstrup code in the packages/browser holder
 * July 2012, by Cresc corp.
 * October 2012, incorporated M1 changes.
 * January 2013, incorporated API changes.
 * February 2013, incorporated API change (Date -> DateTime).
 */

import 'dart:html';
import 'dart:async';
import 'dart:isolate' as isolate;

// top level child isolate function
childIsolate() {
  // long-lived ports
  var receivePort;
  var sendPort;
  // establish communication link
  receivePort = isolate.port;
  var completer = new Completer();
  Future linkEstablished = completer.future;
  receivePort.receive((msg, replyTo){
    sendPort = replyTo;
    replyTo.send('hello', receivePort.toSendPort());
    completer.complete(true);
  });
  linkEstablished.then((value){
    // established, then next state
    receivePort.receive((msg, replyTo){ // send return message
      sendPort.send('child echoed : $msg');
    });
    sendPort.send('${new DateTime.now().toString().substring(11)} : child started Fib computing');
    int i = 40;
    int y;
    y = fibo(i);
//  y = fib(i);
    sendPort.send('${new DateTime.now().toString().substring(11)} : child finished Fib(${i}) = ${y}');
  });
}

class IsolateTest {
  // long-lived ports
  var receivePort;
  var sendPort;
  // main process
  void run() {
    // communication link establishment
    Completer completer = new Completer();
    Future linkEstablished = completer.future;
    var isComplete = false;
    var initialSendPort = isolate.spawnFunction(childIsolate);
    log('spawned workerIsolate');
    receivePort = new isolate.ReceivePort();
    initialSendPort.send('hi', receivePort.toSendPort());  // tell the new send port
    receivePort.receive((msg, replyTo){
      sendPort = replyTo; // long-lived send port to the isolate
      log('initial state message received by parent : $msg');
      if (! isComplete){
        completer.complete(true);
        isComplete = true;
      };
    });
    linkEstablished.then(nextState);
    log('end of IsolateTest.run');
  }
  // established, next state
  nextState(value){
    log('link established');
    // do things here like :
    receivePort.receive((msg, replyTo){log('message received by parent : $msg');});
    log('parent started Fibonacci computing');
    int i = 40;
    int y = fib(i);
    log('parent finished Fib(${i}) = ${y}');
  }
}

int fib(int i) {
  if (i < 2) return i;
  return fib(i - 2) + fib(i - 1);
}

int fibo(int i) {
  if (i < 2) return i;
  return fibo(i - 2) + fibo(i - 1);
}

main(){
  new IsolateTest().run();
}

void log(String message) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $message');
  document.body.nodes.add(new Element.html('<div>$timestamp : $message</div>'));
}