/*
 * IsolateTestFibonacci_child.dart
 * After the breaking dart:isolate change, DOM enabled isolate must spawn
 * child isolate using spawnUri. childIsolate in the previous
 *  IsolateTestFibonacci.dart was separated into this file.
 * November 2013, by Terry
 * January 2015, bug fixed
 */

import 'dart:isolate';

// isolate status
final CONNECTING = 1;
final CONNECTED = 2;
final STOPPED = 3;

// message queue
var logMessages = [];

void main(List<String> args, SendPort port) {
  new ChildIsolate().start(port);
}

// top level child isolate class
class ChildIsolate {
  // status
  var status;
  // long-lived ports
  var receivePort;
  var sendPort;

  void start(SendPort port){
    status = CONNECTING;
    receivePort = new ReceivePort();
    sendPort = port;
    log('child started');
    sendPort.send(receivePort.sendPort);  // initiate link establishment
    receivePort.listen((msg){             // receive messages and dispatch them
    if (status == CONNECTING) linkEstablish(msg);
    else if (status == CONNECTED) run(msg);
    });
  }

  // establish communication link
  linkEstablish(msg){
    if (msg == 'ping') {
      sendPort.send('pong');
      status = CONNECTED;
      log('child received : $msg');
      run();
    }
  }

  // after link establishment, do things here using receivePort and sendPort like:
  run([msg = null]){
    if (msg != null) log('child received : $msg');
    if (msg == null) { // active transmission
      log('child started Fibonacci computing');
      var stopwatch = new Stopwatch()..start();
      int i = 40;
      int y = fib(i);
      stopwatch.stop;
      log('child finished Fib(${i}) = ${y} in ${stopwatch.elapsedMilliseconds}mS');
    }
    else if (msg == 'quit') { // on close command
      for (var m in logMessages) sendPort.send(m); // send queued messages
      status = STOPPED;
      receivePort.close();
      log('child closed it\'s receive port');
    }
  }

  // return log to the parent
  void log(String msg) {
    String timestamp = new DateTime.now().toString().substring(11);
    msg = '$timestamp : $msg';
    print(msg);  // for JS console
    logMessages.add(msg);
  }

  // Fibonacci function
  int fib(int i) {
    if (i < 2) return i;
    return fib(i - 2) + fib(i - 1);
  }
}


