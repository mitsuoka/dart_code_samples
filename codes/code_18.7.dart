// Dart code sample for establishing communications link between isolates

import 'dart:isolate';
import 'dart:math';
//import 'dart:html'; // enable this to run on  Dartium or Dert2JS

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
  log('child started');

  // after link establishment, do things here using receivePort and sendPort like:
  run([msg = null]) {
    if (msg != null) log('child received : $msg');
    if (msg == null) {
      // active transmission
      sendPort.send('${new DateTime.now().toString().substring(11)}'
          ' : child started Fib computing');
      int i = 40;
      int y;
      y = fibo(i);
      //  y = fib(i);
      sendPort.send('${new DateTime.now().toString().substring(11)}'
          ' : child finished Fib(${i}) = ${y}');
    } else {
      sendPort.send('child echoed : $msg'); // simple echo
    }
  }

  // establish communication link
  sendPort.send(receivePort.sendPort);
  linkEstablish(msg) {
    if (msg == 'ping') {
      log('child received : $msg');
      sendPort.send('pong');
      status = CONNECTED;
      run();
    }
  }

  // receive messages and dispatch them
  receivePort.listen((msg) {
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
  linkEstablish(msg) {
    if (msg is SendPort) {
      sendPort = msg;
      sendPort.send('ping');
    } else if (msg == 'pong') {
      log('main received : $msg');
      log('link established');
      status = CONNECTED;
      run();
    }
  }

  // link established, then do things here
  run([msg = null]) {
    if (msg == null) {
      // active transmission
      log('parent started Fibonacci computing');
      int i = 40;
      int y = fib(i);
      log('parent finished Fib(${i}) = ${y}');
    } else log('main received : $msg'); // response transmission
  }

  // main process
  void main() {
    // communication link establishment
    Isolate.spawn(childIsolate, receivePort.sendPort).then((iso) {
      log('spawned child isolate #${iso.hashCode}');
    }); // receive messages and dispatch them
    receivePort.listen((msg) {
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

main() {
  new ParentIsolate().main();
}

void log(String msg) {
  String timestamp = new DateTime.now().toString().substring(11);
  print('$timestamp : $msg');
  //enable next line to run on Dartium or Dart2JS
//  document.body.nodes.add(new Element.html('<div>$msg</div>'));
}
