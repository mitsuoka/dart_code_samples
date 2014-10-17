/*
 * IsolateTest_child.dart
 * After the breaking dart:isolate change, DOM enabled isolate must spawn
 * child isolate using spawnUri. childIsolate in the previous IsolateTest.dart
 * was separated into this file.
 * November 2013, by Terry
 */

import 'dart:isolate';
import 'dart:math';

// isolate status
final CONNECTING = 1;
final CONNECTED = 2;
final STOPPED = 3;

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
      sendPort.send({'one way message from child':[1,2,3,5]}); // send Map with List
    }
    else if (msg is List) {  // echo back the List with added elements
      msg.addAll([', and cos pi is ', cos(PI)]);
      sendPort.send(msg);
    }
    else if (msg == 'quit') { // close command
      status = STOPPED;
      receivePort.close();
      log('child closed it\'s receive port');
    }
    else {
      sendPort.send('child echoed : $msg');  // simple echo
    }
  }

  // return log to the parent
  void log(String msg) {
    String timestamp = new DateTime.now().toString().substring(11);
    sendPort.send('$timestamp : $msg');  // child can not call print() method
  }
}
