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
 * november 2013, incorporated dart:isolate breaking changes
 */

import 'dart:html';
import 'dart:async';
import 'dart:isolate';

// isolate status
final CONNECTING = 1;
final CONNECTED = 2;
final STOPPED = 3;

// top level child isolate function
childIsolate(SendPort port) {
  // status
  var status = CONNECTING;
  // long-lived ports
  var receivePort = new ReceivePort();
  var sendPort = port;

  // after link establishment, do things here using receivePort and sendPort like:
  run([msg = null]){
    if (msg == null) { // active transmission
      sendPort.send('${new DateTime.now().toString().substring(11)}'
                    ' : child started Fibonacci computing');
      int i = 40;
      int y;
      y = fibo(i);
//  y = fib(i);
      sendPort.send('${new DateTime.now().toString().substring(11)}'
                    ' : child finished Fib(${i}) = ${y}');
    }
    else {
      sendPort.send('child echoed : $msg');  // simple echo
    }
  }

  // establish communication link
  sendPort.send(receivePort.sendPort);
  linkEstablish(msg){
    if (msg == 'ping') {
      log('child received : $msg');
      sendPort.send('pong');
      status = CONNECTED;
      run();
    }
  }

  // receive messages and dispatch them
  receivePort.listen((msg){
    if (status == CONNECTING) linkEstablish(msg);
    else if (status == CONNECTED) run(msg);
    });
}

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
      int i = 40;
      int y = fib(i);
      log('parent finished Fib(${i}) = ${y}');
    }
    else log('main received : $msg');  // response transmission
  }

  // main process
  void main() {
    // communication link establishment
    Isolate.spawn(childIsolate, receivePort.sendPort).then((iso){
      log('spawned child isolate #${iso.hashCode}');
    });  // receive messages and dispatch them
    receivePort.listen((msg){
      if (status == CONNECTING) linkEstablish(msg);
      else if (status == CONNECTED) run(msg);
    });
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
  new ParentIsolate().main();
}

void log(String message) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $message');
  document.body.nodes.add(new Element.html('<div>$timestamp : $message</div>'));
}