import 'dart:isolate';
import 'dart:async';

costlyIsolate(reply){
    new Timer(new Duration(seconds: 1), () => reply.send('costly'));
}

expensiveIsolate(reply){
    new Timer(new Duration(seconds: 2), () => reply.send('expensive'));
}

lengthyIsolate(reply){
    new Timer(new Duration(seconds: 3), () => reply.send('lengthy'));
}

costlyQuery() {
  var reply = new ReceivePort();
  var completer = new Completer();
  Isolate.spawn(costlyIsolate, reply.sendPort)
    .then((_) => reply.first)
    .then((msg) {completer.complete(msg);});
  return completer.future;
}

expensiveWork() {
  var reply = new ReceivePort();
  var completer = new Completer();
  Isolate.spawn(expensiveIsolate, reply.sendPort)
    .then((_) => reply.first)
    .then((msg) {completer.complete(msg);});
  return completer.future;
}

lengthyComputation() {
  var reply = new ReceivePort();
  var completer = new Completer();
  Isolate.spawn(lengthyIsolate, reply.sendPort)
    .then((_) => reply.first)
    .then((msg) {completer.complete(msg);});
  return completer.future;
}

void main() {

  // process each time it completes
  costlyQuery().then((value){print(value);});
  expensiveWork().then((value){print(value);});
  lengthyComputation().then((value){print(value);});

/*
  // wait for all complete
  Future.wait([costlyQuery(), expensiveWork(), lengthyComputation()])
  .then((List values) {
    print(values);
  });
*/
}