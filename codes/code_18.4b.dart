// spawning an isolate using spawnUri
import 'dart:isolate';
import 'dart:async';
main() {
  var response = new ReceivePort();
  Future<Isolate> remote =
      Isolate.spawnUri(Uri.parse('code_18.4c.dart'), ['foo'], response.sendPort);
  remote.then((_) => response.first)
    .then((msg) { print('received: $msg'); });
}