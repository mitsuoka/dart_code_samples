import 'dart:async';
final testData = ['a', 'b', 'c', 'd', 'e'];

main() {
  var stream = new Stream.fromIterable(testData);
  var broadcastStream = stream.asBroadcastStream();
  broadcastStream.single.then((value) => print('stream.single: $value'))
    .catchError((err){
       print('AsyncError : ${err}');
       print('Stack Trace : ${getAttachedStackTrace(err)}');
     });
  broadcastStream.first.then((value) => print('stream.first: $value'));     // a
  broadcastStream.last.then((value) => print('stream.last: $value'));       // e
  broadcastStream.isEmpty.then((value) => print('stream.isEmpty: $value')); // false
  broadcastStream.length.then((value) => print('stream.length: $value'));   // 5
  broadcastStream.listen( (value) {
    print('Received: ${value}'); // onData handler
  });
}