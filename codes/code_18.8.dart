import 'dart:isolate' as iso;
import 'dart:async';

costlyIsolate(){
  iso.port.receive((msg, reply) {
    new Timer(new Duration(seconds: 1), () => reply.send('costly'));
  });
}

expensiveIsolate(){
  iso.port.receive((msg, reply) {
    new Timer(new Duration(seconds: 2), () => reply.send('expensive'));
  });
}

lengthyIsolate(){
  iso.port.receive((msg, reply) {
    new Timer(new Duration(seconds: 3), () => reply.send('lengthy'));
  });
}

costlyQuery() {
  var completer = new Completer();
  return iso.spawnFunction(costlyIsolate).call('');
}

expensiveWork() {
  var completer = new Completer();
  return iso.spawnFunction(expensiveIsolate).call('');
}

lengthyComputation() {
  var completer = new Completer();
  return iso.spawnFunction(lengthyIsolate).call('');
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