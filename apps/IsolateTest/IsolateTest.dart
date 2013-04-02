// Dart code sample for establishing communications link between isolates
// Tested on Dartium
// Source : www.cresc.co.jp/tech/java/Google_Dart/DartLanguageGuide.pdf (in Japanese)
// March 2012, by Cresc corp.
// October 2012, incorporated M1 changes
// January 2013, incorporated API changes
// February 2013,  incorporated API changes

import 'dart:html';
import 'dart:async';
import 'dart:isolate' as isolate;
import 'dart:math' as Math;

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
    // do things here using receivePort and sendPort like:
    sendPort.send({'one way message from the child':[1,2,3,5]}); // send Map with List
    receivePort.receive((msg, replyTo){ // send return message
      if (msg is List) {  // echo back the List with added elements
        msg.addAll([', and cos pi is ', Math.cos(Math.PI)]);
        sendPort.send(msg);
      }
      else { sendPort.send('child echoed : $msg');
      }
    });
//    do{} while (true);  // for thread test
  });
}

// parent isolate class
class ParentIsolate {
  // long-lived ports
  var receivePort;
  var sendPort;
  // main process
  void run() {
    // communication link establishment
    Completer completer = new Completer();
    Future linkEstablished = completer.future;
    var isComplete = false;
    sendPort = isolate.spawnFunction(childIsolate);
    log('spawned workerIsolate');
    receivePort = new isolate.ReceivePort();
    sendPort.send('hi', receivePort.toSendPort());  // tell the new send port
    receivePort.receive((msg, replyTo){
      log('initial state message received by parent : $msg');
      if (! isComplete){
        completer.complete(true);
        isComplete = true;
      };
    });
    linkEstablished.then(nextState);
    log('end of IsolateTest.run');
  }
  // link established, proceed to the next state
  // do things here using receivePort and sendPort like:
  nextState(value) {
    log('link established');
    receivePort.receive((msg, replyTo){
      log('state 2 message received by the parent : $msg');});
    sendPort.send('one way message from the parent');
    var myList = ['pi is ' , Math.PI];
    sendPort.send(myList);  // you can send List, Map and other object also
    // for thread test
//    window.setInterval((){log('thread testing...');}, 1000);
  }
}

main() {
  new ParentIsolate().run();
}

void log(String msg) {
  String timestamp = new DateTime.now().toString();
  print('$timestamp : $msg');
  document.body.nodes.add(new Element.html('<div>$msg</div>'));
}